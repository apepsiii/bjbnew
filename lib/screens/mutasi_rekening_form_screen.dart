import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../widgets/bjb_date_picker_bottom_sheet.dart';
import 'mutasi_rekening_hasil_screen.dart';

/// Form Permintaan Mutasi Rekening 1:1 sesuai 9mutasi_rekening_page_dari card_manajemen_keuangan.jpeg
class MutasiRekeningFormScreen extends StatefulWidget {
  final UserModel user;

  const MutasiRekeningFormScreen({super.key, required this.user});

  @override
  State<MutasiRekeningFormScreen> createState() =>
      _MutasiRekeningFormScreenState();
}

class _MutasiRekeningFormScreenState extends State<MutasiRekeningFormScreen> {
  // Tanggal default Agustus 2026 untuk menampilkan transaksi referensi asli
  late DateTime _startDate;
  late DateTime _endDate;
  final TextEditingController _emailController = TextEditingController();
  String _selectedTransactionType = 'Semua Transaksi';

  @override
  void initState() {
    super.initState();
    // Default sesuai rentang di referensi: 1 Agustus 2026 - 30 Agustus 2026
    _startDate = DateTime(2026, 8, 1);
    _endDate = DateTime(2026, 8, 30);
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  void _pickStartDate() async {
    final picked = await BjbDatePickerBottomSheet.show(
      context,
      title: 'Atur tanggal mulai',
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 29));
        }
      });
    }
  }

  void _pickEndDate() async {
    final picked = await BjbDatePickerBottomSheet.show(
      context,
      title: 'Atur tanggal akhir',
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _onTampilkan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MutasiRekeningHasilScreen(
          user: widget.user,
          startDate: _startDate,
          endDate: _endDate,
          targetEmail: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final liveTimeString = DateFormat('dd/MM/yyyy\nHH:mm:ss').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Dari Tanggal
            const Text(
              'Dari Tanggal',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),

            // Field Dari Tanggal
            GestureDetector(
              onTap: _pickStartDate,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDisplayDate(_startDate),
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Label Sampai Tanggal
            const Text(
              'Sampai Tanggal',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),

            // Field Sampai Tanggal
            GestureDetector(
              onTap: _pickEndDate,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDisplayDate(_endDate),
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Label Jenis Transaksi
            const Text(
              'Jenis Transaksi',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),

            // Dropdown Jenis Transaksi
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTransactionType,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF64748B),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Semua Transaksi',
                      child: Text(
                        'Semua Transaksi',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Transaksi Debit',
                      child: Text('Transaksi Debit'),
                    ),
                    DropdownMenuItem(
                      value: 'Transaksi Kredit',
                      child: Text('Transaksi Kredit'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedTransactionType = val);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Label Email
            const Text(
              'Email',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),

            // Input Field Email
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Input email',
                    hintStyle: TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 14.5,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3 Disclaimer Bullet Points (1:1 sesuai 9mutasi_rekening_page_dari...)
            const Text(
              '*) Data transaksi yang dapat ditampilkan adalah 3 Bulan terakhir sejak hari ini\n'
              '*) Data transaksi berdasarkan range hari maksimal 1 Bulan\n'
              '*) Untuk membuat file pdf mutasi rekening gunakan tanggal lahir anda dengan format ddmmyyyy (Tanggal Bulan Tahun lahir anda. Contoh: 06081980)',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
                height: 1.45,
              ),
            ),

            const SizedBox(height: 36),

            // Tombol Kuning "Tampilkan"
            GestureDetector(
              onTap: _onTampilkan,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDB913),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFDB913).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Tampilkan',
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
