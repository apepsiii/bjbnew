import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/statement_request.dart';

/// Layanan pembuatan dan pengelolaan dokumen PDF Rekening Koran Bank BJB
class PdfService {
  PdfService._();

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  /// Menghasilkan file PDF Rekening Koran resmi Bank BJB
  static Future<File> generateStatementPdf(StatementRequest request) async {
    final pdf = pw.Document(
      title: 'Rekening Koran Bank BJB - ${request.user.accountNumber}',
      author: 'PT BANK PEMBANGUNAN DAERAH JAWA BARAT DAN BANTEN, Tbk',
    );

    // Ambil logo BJB jika tersedia di asset
    pw.MemoryImage? bjbLogoImage;
    try {
      final ByteData logoData = await rootBundle.load('assets/images/banks/digi_logo.png');
      bjbLogoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {
      // Fallback jika tidak ditemukan
    }

    final double openingBalance = request.transactions.isNotEmpty
        ? (request.transactions.first.balanceAfter -
            (request.transactions.first.isCredit
                ? request.transactions.first.amount
                : -request.transactions.first.amount))
        : request.user.balance;

    final double closingBalance = request.transactions.isNotEmpty
        ? request.transactions.last.balanceAfter
        : request.user.balance;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        build: (pw.Context context) {
          return [
            // HEADER DOKUMEN BJB
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (bjbLogoImage != null)
                      pw.Container(
                        height: 38,
                        child: pw.Image(bjbLogoImage),
                      )
                    else
                      pw.Text(
                        'bank bjb',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#0083C9'),
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'PT BANK PEMBANGUNAN DAERAH JAWA BARAT DAN BANTEN, Tbk',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColor.fromHex('#4A5568'),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Kantor Pusat: Jl. Naripan No. 12-14 Bandung 40111',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      'Call Center BJB: 14049 | Website: www.bankbjb.co.id',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#0083C9'),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        'REKENING KORAN',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'STATEMENT OF ACCOUNT',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Tanggal Cetak: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())} WIB',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1.5, color: PdfColor.fromHex('#00588A')),
            pw.SizedBox(height: 8),

            // INFORMASI NASABAH & REKENING
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8FAFC'),
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColor.fromHex('#CBD5E1'), width: 0.8),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nama Nasabah', request.user.fullName),
                        _buildInfoRow('Nomor Rekening', request.user.accountNumber),
                        _buildInfoRow('Nomor CIF', request.user.cif),
                        _buildInfoRow('Produk / Tabungan', request.user.accountType),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Periode Laporan',
                          '${_dateFormat.format(request.startDate)} s/d ${_dateFormat.format(request.endDate)}',
                        ),
                        _buildInfoRow('Mata Uang', 'IDR (Indonesian Rupiah)'),
                        _buildInfoRow('Alamat Email', request.targetEmail),
                        _buildInfoRow('Cabang Pengelola', request.user.branchName),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // RINGKASAN SALDO
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromHex('#0083C9'), width: 1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Saldo Awal', _currencyFormat.format(openingBalance)),
                  _buildSummaryItem('Total Debet (Keluar)', _currencyFormat.format(request.totalDebit), isDebit: true),
                  _buildSummaryItem('Total Kredit (Masuk)', _currencyFormat.format(request.totalCredit), isCredit: true),
                  _buildSummaryItem('Saldo Akhir', _currencyFormat.format(closingBalance), isBold: true),
                ],
              ),
            ),

            pw.SizedBox(height: 14),

            // TABEL RINCIAN MUTASI
            pw.Text(
              'RINCIAN TRANSAKSI',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#00588A'),
              ),
            ),
            pw.SizedBox(height: 6),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColor.fromHex('#CBD5E1'), width: 0.5),
              columnWidths: const {
                0: pw.FixedColumnWidth(60),
                1: pw.FlexColumnWidth(3),
                2: pw.FixedColumnWidth(65),
                3: pw.FixedColumnWidth(75),
                4: pw.FixedColumnWidth(75),
                5: pw.FixedColumnWidth(85),
              },
              children: [
                // Header Tabel
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex('#0083C9')),
                  children: [
                    _buildTableHeader('Tanggal'),
                    _buildTableHeader('Keterangan'),
                    _buildTableHeader('No. Ref'),
                    _buildTableHeader('Debet (Rp)'),
                    _buildTableHeader('Kredit (Rp)'),
                    _buildTableHeader('Saldo (Rp)'),
                  ],
                ),
                // Data Baris Mutasi
                ...request.transactions.map((tx) {
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: request.transactions.indexOf(tx) % 2 == 0
                          ? PdfColors.white
                          : PdfColor.fromHex('#F8FAFC'),
                    ),
                    children: [
                      _buildTableCell(_dateFormat.format(tx.date), align: pw.TextAlign.center),
                      _buildTableCell(tx.description),
                      _buildTableCell(tx.referenceNumber, align: pw.TextAlign.center),
                      _buildTableCell(
                        tx.isCredit ? '-' : NumberFormat('#,##0.00', 'id_ID').format(tx.amount),
                        align: pw.TextAlign.right,
                        color: tx.isCredit ? null : PdfColor.fromHex('#DC3545'),
                      ),
                      _buildTableCell(
                        tx.isCredit ? NumberFormat('#,##0.00', 'id_ID').format(tx.amount) : '-',
                        align: pw.TextAlign.right,
                        color: tx.isCredit ? PdfColor.fromHex('#28A745') : null,
                      ),
                      _buildTableCell(
                        NumberFormat('#,##0.00', 'id_ID').format(tx.balanceAfter),
                        align: pw.TextAlign.right,
                        isBold: true,
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 18),

            // DISCLAIMER & CATATAN BANK BJB
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F1F5F9'),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Catatan Resmi Bank BJB:',
                    style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    '1. Dokumen ini dicetak secara elektronik melalui aplikasi DIGI bank bjb dan memiliki keabsahan hukum yang sah tanpa tanda tangan basah.',
                    style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    '2. Apabila terdapat perbedaan data transaksi pada Rekening Koran ini, nasabah diharapkan segera melapor ke kantor operasional Bank BJB terdekat atau hubungi BJB Call 14049 selambat-lambatnya 14 hari kalender.',
                    style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    '3. Bank BJB terdaftar dan diawasi oleh Otoritas Jasa Keuangan (OJK) serta merupakan peserta penjaminan Lembaga Penjamin Simpanan (LPS).',
                    style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/Rekening_Koran_BJB_${request.user.accountNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 85,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
            ),
          ),
          pw.Text(': ', style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value, {
    bool isCredit = false,
    bool isDebit = false,
    bool isBold = false,
  }) {
    PdfColor valColor = PdfColors.grey900;
    if (isCredit) valColor = PdfColor.fromHex('#28A745');
    if (isDebit) valColor = PdfColor.fromHex('#DC3545');

    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 8.5,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: valColor,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? color,
    bool isBold = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 7.5,
          color: color ?? PdfColors.grey900,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
