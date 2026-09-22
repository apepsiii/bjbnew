import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:printing/printing.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../models/statement_request.dart';
import '../services/pdf_service.dart';
import '../services/email_service.dart';
import '../widgets/bjb_app_bar.dart';

/// Layar penampil dokumen PDF Rekening Koran terintegrasi beserta status pengiriman email
class PdfViewerScreen extends StatefulWidget {
  final StatementRequest request;

  const PdfViewerScreen({super.key, required this.request});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  File? _pdfFile;
  bool _isGeneratingPdf = true;
  bool _isSendingEmail = false;
  String? _emailStatusMessage;
  bool _emailSuccess = false;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _generateAndSendStatement();
  }

  Future<void> _generateAndSendStatement() async {
    setState(() {
      _isGeneratingPdf = true;
      _isSendingEmail = true;
      _emailStatusMessage = 'Sedang membuat dokumen rekening koran...';
    });

    try {
      // 1. Generate PDF
      final file = await PdfService.generateStatementPdf(widget.request);

      if (!mounted) return;
      setState(() {
        _pdfFile = file;
        _isGeneratingPdf = false;
        _emailStatusMessage = 'Mengirimkan dokumen ke ${widget.request.targetEmail}...';
      });

      // 2. Otomatis kirim email
      final periodStr =
          '${_dateFormat.format(widget.request.startDate)} s/d ${_dateFormat.format(widget.request.endDate)}';

      final emailResult = await EmailService.sendStatementEmail(
        recipientEmail: widget.request.targetEmail,
        customerName: widget.request.user.fullName,
        accountNumber: widget.request.user.accountNumber,
        periodStr: periodStr,
        pdfFile: file,
      );

      if (!mounted) return;
      setState(() {
        _isSendingEmail = false;
        _emailSuccess = emailResult.isSuccess;
        _emailStatusMessage = emailResult.message;
      });

      // Tampilkan notifikasi toast/snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: emailResult.isSuccess ? AppColors.secondary : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            children: [
              Icon(
                emailResult.isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  emailResult.message,
                  style: const TextStyle(fontFamily: AppAssets.fontFamily),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGeneratingPdf = false;
        _isSendingEmail = false;
        _emailSuccess = false;
        _emailStatusMessage = 'Terjadi kesalahan: ${e.toString()}';
      });
    }
  }

  Future<void> _openExternalPdf() async {
    if (_pdfFile != null && _pdfFile!.existsSync()) {
      await OpenFilex.open(_pdfFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BjbAppBar(
        title: 'Preview Rekening Koran',
        actions: [
          if (_pdfFile != null)
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
              tooltip: 'Buka di Viewer Eksternal',
              onPressed: _openExternalPdf,
            ),
        ],
      ),
      body: Column(
        children: [
          // Banner Status Pengiriman Email
          _buildEmailStatusBar(),

          // Area Tampilan PDF
          Expanded(
            child: _isGeneratingPdf
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Membuat Dokumen Rekening Koran BJB...',
                          style: TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : _pdfFile != null
                    ? PdfPreview(
                        build: (format) => _pdfFile!.readAsBytes(),
                        canChangePageFormat: false,
                        canChangeOrientation: false,
                        canDebug: false,
                        pdfFileName: 'Rekening_Koran_BJB_${widget.request.user.accountNumber}.pdf',
                        scrollViewDecoration: const BoxDecoration(
                          color: AppColors.background,
                        ),
                        actions: [
                          PdfPreviewAction(
                            icon: const Icon(Icons.forward_to_inbox_rounded),
                            onPressed: (context, build, pageFormat) async {
                              _generateAndSendStatement();
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          _emailStatusMessage ?? 'Gagal memuat dokumen PDF.',
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            color: AppColors.error,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isSendingEmail
            ? const Color(0xFFEBF8FF)
            : _emailSuccess
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
        border: Border(
          bottom: BorderSide(
            color: _isSendingEmail
                ? const Color(0xFFBAE6FD)
                : _emailSuccess
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFFECACA),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_isSendingEmail)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          else
            Icon(
              _emailSuccess ? Icons.mark_email_read_rounded : Icons.mail_lock_outlined,
              size: 20,
              color: _emailSuccess ? AppColors.success : AppColors.error,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _emailStatusMessage ?? '',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: _isSendingEmail
                    ? const Color(0xFF0369A1)
                    : _emailSuccess
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
              ),
            ),
          ),
          if (!_isSendingEmail)
            TextButton.icon(
              onPressed: _generateAndSendStatement,
              icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                'Kirim Ulang',
                style: TextStyle(
                  fontFamily: AppAssets.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
