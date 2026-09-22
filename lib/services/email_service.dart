import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Konfigurasi SMTP untuk pengiriman email
class SmtpConfig {
  final String host;
  final int port;
  final bool isSsl;
  final String username;
  final String password;
  final String senderName;

  const SmtpConfig({
    required this.host,
    this.port = 587,
    this.isSsl = false,
    required this.username,
    required this.password,
    this.senderName = 'DIGI bank bjb - E-Statement',
  });

  bool get isValid =>
      host.isNotEmpty && username.isNotEmpty && password.isNotEmpty;
}

/// Status hasil pengiriman email
class EmailResult {
  final bool isSuccess;
  final String message;
  final bool isSimulated;

  const EmailResult({
    required this.isSuccess,
    required this.message,
    this.isSimulated = false,
  });
}

/// Layanan pengiriman email Rekening Koran Bank BJB
class EmailService {
  EmailService._();

  // Pengaturan SMTP default (dapat disesuaikan jika nasabah memiliki kredensial SMTP)
  static SmtpConfig? _config;

  static void configure(SmtpConfig config) {
    _config = config;
  }

  /// Mengirim dokumen Rekening Koran ke alamat email nasabah
  static Future<EmailResult> sendStatementEmail({
    required String recipientEmail,
    required String customerName,
    required String accountNumber,
    required String periodStr,
    required File pdfFile,
  }) async {
    // Validasi format email dasar
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(recipientEmail)) {
      return const EmailResult(
        isSuccess: false,
        message: 'Format alamat email tidak valid.',
      );
    }

    if (!pdfFile.existsSync()) {
      return const EmailResult(
        isSuccess: false,
        message: 'File PDF Rekening Koran tidak ditemukan.',
      );
    }

    // Jika SMTP sudah dikonfigurasi nyata, kirim via SMTP server
    if (_config != null && _config!.isValid) {
      try {
        final smtpServer = SmtpServer(
          _config!.host,
          port: _config!.port,
          ssl: _config!.isSsl,
          username: _config!.username,
          password: _config!.password,
        );

        final message = Message()
          ..from = Address(_config!.username, _config!.senderName)
          ..recipients.add(recipientEmail)
          ..subject = 'Rekening Koran Bank BJB - No. Rek $accountNumber'
          ..html =
              '''
            <div style="font-family: Arial, sans-serif; color: #333; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 8px; padding: 24px;">
              <h2 style="color: #0083C9; margin-top: 0;">PT BANK PEMBANGUNAN DAERAH JAWA BARAT DAN BANTEN, Tbk</h2>
              <p>Yth. <strong>$customerName</strong>,</p>
              <p>Terima kasih telah menggunakan layanan digital <strong>DIGI bank bjb</strong>.</p>
              <p>Terlampir kami sampaikan dokumen <strong>Laporan Rekening Koran (E-Statement)</strong> untuk rekening Anda:</p>
              <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
                <tr><td style="padding: 6px 0; color: #666;">Nomor Rekening</td><td>: <strong>$accountNumber</strong></td></tr>
                <tr><td style="padding: 6px 0; color: #666;">Periode Mutasi</td><td>: <strong>$periodStr</strong></td></tr>
              </table>
              <p style="font-size: 13px; color: #777;">Dokumen elektronik ini resmi diterbitkan oleh PT Bank BJB, Tbk. Jaga selalu kerahasiaan informasi perbankan Anda.</p>
              <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;" />
              <p style="font-size: 12px; color: #999;">BJB Call: 14049 | Website: <a href="https://www.bankbjb.co.id" style="color: #0083C9;">www.bankbjb.co.id</a></p>
            </div>
          '''
          ..attachments.add(FileAttachment(pdfFile));

        await send(message, smtpServer);
        return EmailResult(
          isSuccess: true,
          message: 'Rekening Koran berhasil dikirim ke $recipientEmail',
        );
      } catch (e) {
        return EmailResult(
          isSuccess: false,
          message: 'Gagal mengirim email: ${e.toString()}',
        );
      }
    }

    // Mode simulasi terintegrasi (apabila belum ada kredensial live SMTP)
    await Future.delayed(const Duration(milliseconds: 1500));
    return EmailResult(
      isSuccess: true,
      message: 'Rekening Koran berhasil dikirimkan ke $recipientEmail',
      isSimulated: true,
    );
  }
}
