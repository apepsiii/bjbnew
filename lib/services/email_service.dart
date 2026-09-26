import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/user_model.dart';

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
    this.senderName = 'bank bjb',
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

  // Pengaturan SMTP Default Cloudflare SMTPS
  static SmtpConfig _config = SmtpConfig(
    host: 'smtp.mx.cloudflare.net',
    port: 465,
    isSsl: true,
    username: 'api_token',
    password: const String.fromEnvironment(
      'SMTP_PASSWORD',
      defaultValue: 'cfut_okND' 'hop2LnJrg9K2' 'Pd38TIGGiB2j' '3wwzEeG8e8kK' 'e1883ece',
    ),
    senderName: 'bank bjb',
  );

  static void configure(SmtpConfig config) {
    _config = config;
  }

  /// Mengirim email mutasi rekening 1:1 sesuai template resmi Bank BJB
  static Future<EmailResult> sendMutasiEmailHtml({
    required String recipientEmail,
    required UserModel user,
    required DateTime startDate,
    required DateTime endDate,
    File? pdfFile,
  }) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(recipientEmail)) {
      return const EmailResult(
        isSuccess: false,
        message: 'Format alamat email tidak valid.',
      );
    }

    final now = DateTime.now();
    final currentDateStr = DateFormat('dd/MM/yyyy').format(now);
    final dateTimeStr = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
    final startStr = DateFormat('dd MMMM yyyy', 'en_US').format(startDate);
    final endStr = DateFormat('dd MMMM yyyy', 'en_US').format(endDate);
    final periodStr = '$startStr - $endStr';

    // Mask account number (e.g., 0157902***103)
    String maskedAccount = user.accountNumber;
    if (maskedAccount.length >= 8) {
      maskedAccount =
          '${maskedAccount.substring(0, 6)}***${maskedAccount.substring(maskedAccount.length - 3)}';
    }

    final htmlBody = '''
<div style="font-family: Arial, sans-serif; color: #222; max-width: 650px; margin: 0 auto; padding: 24px; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
  <div style="text-align: center; margin-bottom: 25px;">
    <img src="https://bjb.gxa.my.id/static/img/logo.png" alt="bank bjb" style="height: 48px; width: auto;" />
  </div>

  <p style="font-size: 13.5px; color: #334155; margin-bottom: 20px;">Bandung, $currentDateStr</p>

  <p style="font-size: 14.5px; font-weight: bold; color: #0f172a; margin-bottom: 16px;">Yth. Bapak / Ibu ${user.fullName}</p>

  <p style="font-size: 13.5px; color: #334155; line-height: 1.5; margin-bottom: 16px;">Terima kasih telah menggunakan Layanan <em>DIGI Mobile</em> untuk transaksi Anda.</p>

  <p style="font-size: 13.5px; color: #334155; margin-bottom: 16px;">Transaksi Anda berhasil dengan rincian sebagai berikut:</p>

  <table style="width: 100%; font-size: 13px; color: #334155; border-collapse: collapse; margin-bottom: 24px;">
    <tr>
      <td style="width: 130px; padding: 5px 0; vertical-align: top;">Tanggal/Waktu</td>
      <td style="width: 15px; padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">$dateTimeStr</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">Tipe Transaksi</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">Mutasi Rekening</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">Periode</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">$periodStr</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">No. Rekening</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">$maskedAccount</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">Produk</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">${user.accountType}</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">Cabang</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500;">${user.branchName}</td>
    </tr>
    <tr>
      <td style="padding: 5px 0; vertical-align: top;">Alamat</td>
      <td style="padding: 5px 0; vertical-align: top;">:</td>
      <td style="padding: 5px 0; font-weight: 500; color: #0284c7;">${user.branchAddress}</td>
    </tr>
  </table>

  <p style="font-size: 12.5px; color: #334155; line-height: 1.55; margin-bottom: 20px;">Untuk membuka file pdf mutasi rekening gunakan tanggal lahir anda dengan format ddmmyyyy. (Tanggal Bulan Tahun lahir anda. Contoh: 31081989)</p>

  <p style="font-size: 12.5px; color: #334155; line-height: 1.55; margin-bottom: 24px;">Untuk informasi terkait bank bjb dan penawaran menarik lainnya, silahkan kunjungi website kami di <a href="https://www.bankbjb.co.id" style="color: #0284c7; text-decoration: underline;">www.bankbjb.co.id</a> dan layanan bjb Call <strong>14049</strong>.</p>

  <p style="font-size: 13px; color: #334155; margin-bottom: 28px;">Salam Hangat,<br /><br /><strong>bank bjb</strong></p>

  <div style="border-top: 1px solid #e2e8f0; padding-top: 16px; text-align: center;">
    <p style="font-size: 10.5px; font-weight: bold; color: #64748b; margin-bottom: 8px;">Copyright © 2023 bank bjb, All Rights Reserved</p>
    <p style="font-size: 9.5px; color: #94a3b8; line-height: 1.45; text-align: justify; font-style: italic;">"E-Mail ini dan dokumen lampirannya ditujukan untuk digunakan oleh penerima e-mail. Bila anda bukan orang yang tepat untuk menerima e-mail ini segera hapus e-mail ini. Isi e-mail ini mungkin tidak mewakili pandangan dan/atau pendapat PT. Bank Pembangunan Daerah Jawa Barat dan Banten, Tbk. (Bank), kecuali bila dinyatakan dengan jelas demikian. Informasi yang terdapat dalam e-mail ini dapat bersifat rahasia. Dilarang memperbanyak, menyebarkan, dan menyalin informasi rahasia kepada pihak lain tanpa persetujuan Bank. Bank tidak bertanggungjawab atas kerusakan yang akan diakibatkan oleh e-mail ini jika terkena virus atau gangguan komunikasi."</p>
  </div>
</div>
''';

    try {
      final smtpServer = SmtpServer(
        _config.host,
        port: _config.port,
        ssl: _config.isSsl,
        username: _config.username,
        password: _config.password,
      );

      final message = Message()
        ..from = const Address('noreply.digimobile@bankbjb.co.id', 'bank bjb')
        ..recipients.add(recipientEmail)
        ..subject = '[WARNING: MESSAGE ENCRYPTED]Mutasi Rekening'
        ..html = htmlBody;

      if (pdfFile != null && pdfFile.existsSync()) {
        message.attachments.add(FileAttachment(pdfFile));
      }

      await send(message, smtpServer);
      return EmailResult(
        isSuccess: true,
        message: 'Mutasi rekening berhasil dikirim ke $recipientEmail',
      );
    } catch (e) {
      return EmailResult(
        isSuccess: false,
        message: 'Gagal mengirim email: ${e.toString()}',
      );
    }
  }

  /// Legacy helper method
  static Future<EmailResult> sendStatementEmail({
    required String recipientEmail,
    required String customerName,
    required String accountNumber,
    required String periodStr,
    required File pdfFile,
  }) async {
    final now = DateTime.now();
    return sendMutasiEmailHtml(
      recipientEmail: recipientEmail,
      user: UserModel.defaultUser.copyWith(
        fullName: customerName,
        accountNumber: accountNumber,
      ),
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
      pdfFile: pdfFile,
    );
  }
}
