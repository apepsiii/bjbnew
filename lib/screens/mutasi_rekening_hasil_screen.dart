import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../models/transaction_item.dart';
import '../models/statement_request.dart';
import '../services/pdf_service.dart';
import '../services/email_service.dart';
import 'pdf_viewer_screen.dart';

/// Layar Hasil Mutasi Rekening 1:1 sesuai 11mutasi_rekening_hasil__page.jpeg
class MutasiRekeningHasilScreen extends StatefulWidget {
  final UserModel user;
  final DateTime startDate;
  final DateTime endDate;
  final String targetEmail;

  const MutasiRekeningHasilScreen({
    super.key,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.targetEmail,
  });

  @override
  State<MutasiRekeningHasilScreen> createState() =>
      _MutasiRekeningHasilScreenState();
}

class _MutasiRekeningHasilScreenState extends State<MutasiRekeningHasilScreen> {
  late List<TransactionItem> _transactions;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _transactions = TransactionItem.generateSampleTransactions(
      widget.startDate,
      widget.endDate,
      widget.user.balance,
    );
  }

  String _formatCurrency(double amount, bool isCredit) {
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    final formatted = formatter.format(amount);
    return isCredit ? '+ $formatted' : '- $formatted';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'en_US').format(date);
  }

  void _onBagikan() async {
    setState(() => _isGeneratingPdf = true);

    try {
      final request = StatementRequest(
        user: widget.user,
        startDate: widget.startDate,
        endDate: widget.endDate,
        targetEmail: widget.targetEmail.isNotEmpty
            ? widget.targetEmail
            : widget.user.email,
        transactions: _transactions,
      );

      final pdfFile = await PdfService.generateStatementPdf(request);
      final pdfBytes = await pdfFile.readAsBytes();

      if (!mounted) return;
      setState(() => _isGeneratingPdf = false);

      // Tampilkan bottom sheet pilihan aksi Bagikan / Preview / Kirim Email
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bagikan Rekening Koran',
                  style: TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE2F3FD),
                    child: Icon(Icons.picture_as_pdf, color: Color(0xFF0083C9)),
                  ),
                  title: const Text('Buka Dokumen PDF',
                      style: TextStyle(fontFamily: AppAssets.fontFamily, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Lihat preview PDF resmi Bank BJB',
                      style: TextStyle(fontFamily: AppAssets.fontFamily, fontSize: 12.5)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(request: request),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE2F3FD),
                    child: Icon(Icons.share_outlined, color: Color(0xFF0083C9)),
                  ),
                  title: const Text('Bagikan File PDF',
                      style: TextStyle(fontFamily: AppAssets.fontFamily, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Kirim via WhatsApp, Telegram, atau Drive',
                      style: TextStyle(fontFamily: AppAssets.fontFamily, fontSize: 12.5)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename: 'Rekening_Koran_${widget.user.accountNumber}.pdf',
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE2F3FD),
                    child: Icon(Icons.email_outlined, color: Color(0xFF0083C9)),
                  ),
                  title: const Text('Kirim ke Email',
                      style: TextStyle(fontFamily: AppAssets.fontFamily, fontWeight: FontWeight.w600)),
                  subtitle: Text('Kirim ke ${request.targetEmail}',
                      style: const TextStyle(fontFamily: AppAssets.fontFamily, fontSize: 12.5)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Mengirimkan Rekening Koran ke ${request.targetEmail}...',
                          style: const TextStyle(fontFamily: AppAssets.fontFamily),
                        ),
                        backgroundColor: const Color(0xFF0083C9),
                      ),
                    );
                    final periodStr =
                        '${DateFormat('dd/MM/yyyy').format(widget.startDate)} s/d ${DateFormat('dd/MM/yyyy').format(widget.endDate)}';
                    final result = await EmailService.sendStatementEmail(
                      recipientEmail: request.targetEmail,
                      customerName: widget.user.fullName,
                      accountNumber: widget.user.accountNumber,
                      periodStr: periodStr,
                      pdfFile: pdfFile,
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.message,
                          style: const TextStyle(fontFamily: AppAssets.fontFamily),
                        ),
                        backgroundColor: result.isSuccess
                            ? const Color(0xFF28A745)
                            : const Color(0xFFDC3545),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat PDF: $e'),
            backgroundColor: const Color(0xFFDC3545),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final liveTimeString = DateFormat('dd/MM/yyyy\nHH:mm:ss').format(now);
    final periodString =
        '${DateFormat('yyyy-MM-dd').format(widget.startDate)} - ${DateFormat('yyyy-MM-dd').format(widget.endDate)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0083C9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mutasi Rekening',
          style: TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF28A745),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  liveTimeString,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 9.5,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                // Info Box Rekening (1:1 sesuai 11mutasi_rekening_hasil__page.jpeg)
                Container(
                  width: double.infinity,
                  color: const Color(0xFFDCEAF7),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    children: [
                      _buildInfoRow('Periode', ':  $periodString'),
                      const SizedBox(height: 5),
                      _buildInfoRow(
                        'Nomor Rekening',
                        ':  ${widget.user.accountNumber} - ${widget.user.fullName}',
                      ),
                      const SizedBox(height: 5),
                      _buildInfoRow('Produk', ':  ${widget.user.accountType}'),
                      const SizedBox(height: 5),
                      _buildInfoRow('Cabang', ':  ${widget.user.branchName}'),
                      const SizedBox(height: 5),
                      _buildInfoRow('Alamat', ':  ${widget.user.branchAddress}'),
                    ],
                  ),
                ),

                // Daftar Mutasi Transaksi
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transactions.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE2E8F0),
                  ),
                  itemBuilder: (context, index) {
                    final item = _transactions[index];
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Baris 1: Tanggal & Nominal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(item.date),
                                style: const TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                _formatCurrency(item.amount, item.isCredit),
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: item.isCredit
                                      ? const Color(0xFF28A745)
                                      : const Color(0xFFDC3545),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Baris 2: Deskripsi Transaksi
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 12.5,
                              color: Color(0xFF475569),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Baris 3: Label Debit / Kredit di sisi kanan
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              item.isCredit ? 'Kredit' : 'Debit',
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0083C9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      bottomNavigationBar: Container(
        color: const Color(0xFFEAF2FA),
        child: SafeArea(
          top: false,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pagination
                const Row(
                  children: [
                    Text(
                      'Prev',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(width: 14),
                    Text(
                      '1',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00588A),
                      ),
                    ),
                    SizedBox(width: 14),
                    Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),

                // Tombol Bagikan
                GestureDetector(
                  onTap: _isGeneratingPdf ? null : _onBagikan,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isGeneratingPdf)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        const Icon(
                          Icons.share_outlined,
                          size: 16,
                          color: Color(0xFF00588A),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Bagikan',
                          style: TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00588A),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppAssets.fontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: AppAssets.fontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
