import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../models/transaction_item.dart';
import '../models/statement_request.dart';
import '../services/api_service.dart';
import '../services/pdf_service.dart';

/// Layar Hasil Mutasi Rekening 1:1 sesuai desain referensi context/design_reference/new/11mutasi_rekening_hasil__page.jpeg
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
  bool _isLoadingApi = true;
  bool _isDownloadingPdf = false;

  @override
  void initState() {
    super.initState();
    _transactions = TransactionItem.generateSampleTransactions(
      widget.startDate,
      widget.endDate,
      widget.user.balance,
    );
    _loadMutasiFromApi();
  }

  Future<void> _loadMutasiFromApi() async {
    final startStr = DateFormat('yyyy-MM-dd').format(widget.startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(widget.endDate);

    var apiTransactions = await ApiService.getMutasi(
      startDate: startStr,
      endDate: endStr,
    );

    if (apiTransactions.isEmpty) {
      apiTransactions = await ApiService.getMutasi();
    }

    if (mounted) {
      setState(() {
        if (apiTransactions.isNotEmpty) {
          _transactions = apiTransactions;
        }
        _isLoadingApi = false;
      });
    }
  }

  String _formatCurrency(double amount, bool isCredit) {
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    final formatted = formatter.format(amount);
    return isCredit ? '+ $formatted' : '- $formatted';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'en_US').format(date);
  }

  // Langsung mendownload file PDF mutasi asli dari backend tanpa membuka di browser
  void _onBagikan() async {
    if (_isDownloadingPdf) return;

    setState(() => _isDownloadingPdf = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengunduh berkas Rekening Koran PDF... Mohon tunggu.'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final periods = await ApiService.getStatementPeriods();
      int? targetStmtId;
      if (periods.isNotEmpty) {
        targetStmtId = periods.first['id'] as int?;
      }

      final downloadedPath = await ApiService.downloadStatementPDF(statementId: targetStmtId);

      if (!mounted) return;
      setState(() => _isDownloadingPdf = false);

      if (downloadedPath != null && File(downloadedPath).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Berkas Rekening Koran berhasil diunduh:\n$downloadedPath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        await OpenFilex.open(downloadedPath);
      } else {
        final request = StatementRequest(
          user: widget.user,
          startDate: widget.startDate,
          endDate: widget.endDate,
          targetEmail: widget.targetEmail.isNotEmpty ? widget.targetEmail : widget.user.email,
          transactions: _transactions,
        );

        final pdfFile = await PdfService.generateStatementPdf(request);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Berkas Rekening Koran dibuat:\n${pdfFile.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        await OpenFilex.open(pdfFile.path);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloadingPdf = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final liveTimeString = DateFormat('dd/MM/yyyy\nHH:mm:ss').format(now);
    final startFormatted = DateFormat('yyyy-MM-dd').format(widget.startDate);
    final endFormatted = DateFormat('yyyy-MM-dd').format(widget.endDate);

    return Scaffold(
      backgroundColor: const Color(0xFFD9ECFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0083C9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
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
                    const SizedBox(width: 4),
                    Text(
                      liveTimeString,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 9.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Informasi Rekening & Periode (1:1 Sesuai 11mutasi_rekening_hasil__page.jpeg)
          Container(
            color: const Color(0xFFD9ECFA),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Periode', ': $startFormatted - $endFormatted'),
                const SizedBox(height: 3),
                _buildInfoRow('Nomor Rekening', ': ${widget.user.accountNumber} - ${widget.user.fullName}'),
                const SizedBox(height: 3),
                _buildInfoRow('Produk', ': ${widget.user.accountType}'),
                const SizedBox(height: 3),
                _buildInfoRow('Cabang', ': ${widget.user.branchName}'),
                const SizedBox(height: 3),
                _buildInfoRow('Alamat', ': ${widget.user.branchAddress}'),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFBCCCDC)),

          // List Transaksi Mutasi Flat Layout (1:1 Sesuai Gambar Referensi)
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFCBD5E1),
              ),
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return Container(
                  color: const Color(0xFFE8F2FC),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Atas: Tanggal & Jumlah Nominal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(tx.date),
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          Text(
                            _formatCurrency(tx.amount, tx.isCredit),
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: tx.isCredit
                                  ? const Color(0xFF28A745)
                                  : const Color(0xFFDC3545),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Baris Bawah: Deskripsi Transaksi & Badge Status (Debit/Kredit)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              tx.description,
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475569),
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tx.isCredit ? 'Kredit' : 'Debit',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Navigation Bar (Prev 1 Next | < Bagikan 1:1 Sesuai Gambar)
          Container(
            color: const Color(0xFFD9ECFA),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pagination Status
                const Row(
                  children: [
                    Text(
                      'Prev  ',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1  ',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Button Bagikan (Direct Download PDF)
                GestureDetector(
                  onTap: _isDownloadingPdf ? null : _onBagikan,
                  child: Row(
                    children: [
                      _isDownloadingPdf
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0083C9),
                              ),
                            )
                          : const Icon(
                              Icons.share_outlined,
                              size: 16,
                              color: Color(0xFF0083C9),
                            ),
                      const SizedBox(width: 4),
                      Text(
                        _isDownloadingPdf ? 'Mengunduh...' : 'Bagikan',
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0083C9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
              fontSize: 12,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: AppAssets.fontFamily,
              fontSize: 12,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
