import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../models/statement_request.dart';
import '../models/transaction_item.dart';
import '../widgets/bjb_app_bar.dart';
import '../widgets/bjb_button.dart';
import '../widgets/bjb_text_field.dart';
import 'pdf_viewer_screen.dart';

/// Layar Form Permintaan Rekening Koran (Date Range Picker & Email Input)
class StatementFormScreen extends StatefulWidget {
  final UserModel user;

  const StatementFormScreen({super.key, required this.user});

  @override
  State<StatementFormScreen> createState() => _StatementFormScreenState();
}

class _StatementFormScreenState extends State<StatementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _dateRangeController;

  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    // Default rentang: 1 bulan terakhir hingga hari ini
    _endDate = DateTime.now();
    _startDate = DateTime.now().subtract(const Duration(days: 30));

    _emailController = TextEditingController(text: widget.user.email);
    _dateRangeController = TextEditingController(
      text:
          '${_dateFormat.format(_startDate)} - ${_dateFormat.format(_endDate)}',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _dateRangeController.text =
            '${_dateFormat.format(_startDate)} - ${_dateFormat.format(_endDate)}';
      });
    }
  }

  void _submitStatementRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Siapkan mutasi transaksi realistis untuk rekening koran
    final transactions = TransactionItem.generateSampleTransactions(
      _startDate,
      _endDate,
      widget.user.balance - 5000000,
    );

    final request = StatementRequest(
      user: widget.user,
      startDate: _startDate,
      endDate: _endDate,
      targetEmail: _emailController.text.trim(),
      transactions: transactions,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(request: request),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BjbAppBar(title: 'Cetak Rekening Koran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card Rekening Terpilih
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.accountType,
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.user.accountNumber,
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'A/N ${widget.user.fullName}',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Pengaturan Periode & Tujuan',
                style: TextStyle(
                  fontFamily: AppAssets.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih periode mutasi transaksi yang ingin dicetak ke dalam laporan rekening koran.',
                style: TextStyle(
                  fontFamily: AppAssets.fontFamily,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              // Date Range Picker Field
              BjbTextField(
                controller: _dateRangeController,
                labelText: 'Periode Transaksi (Mulai - Selesai)',
                hintText: 'Pilih rentang tanggal',
                readOnly: true,
                onTap: _pickDateRange,
                prefixIcon: const Icon(
                  Icons.date_range_outlined,
                  color: AppColors.primary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: _pickDateRange,
                ),
              ),

              const SizedBox(height: 18),

              // Email Input Field
              BjbTextField(
                controller: _emailController,
                labelText: 'Kirim Salinan ke Email',
                hintText: 'contoh@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.primary,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Alamat email wajib diisi';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Masukkan format alamat email yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Kotak Informasi / Ketentuan
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB9E1F7)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi E-Statement Bank BJB',
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '• Rekening koran mencakup seluruh mutasi debit & kredit pada rentang tanggal yang dipilih.\n• Dokumen PDF dilengkapi stempel digital Bank BJB dan dapat langsung diunduh atau dikirimkan ke email terdaftar.',
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 11.5,
                              color: Color(0xFF334155),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Submit
              BjbButton(
                text: 'KIRIM & TAMPILKAN REKENING KORAN',
                icon: Icons.picture_as_pdf_outlined,
                isLoading: _isLoading,
                onPressed: _submitStatementRequest,
              ),

              SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
