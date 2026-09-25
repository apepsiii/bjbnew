import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../widgets/bjb_date_picker_bottom_sheet.dart';
import 'mutasi_rekening_hasil_screen.dart';

/// Form Permintaan Mutasi Rekening 1:1 sesuai foto referensi mutasi_rekening_form_page.jpeg
class MutasiRekeningFormScreen extends StatefulWidget {
  final UserModel user;

  const MutasiRekeningFormScreen({super.key, required this.user});

  @override
  State<MutasiRekeningFormScreen> createState() =>
      _MutasiRekeningFormScreenState();
}

class _MutasiRekeningFormScreenState extends State<MutasiRekeningFormScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  final TextEditingController _emailController = TextEditingController();
  String _selectedTransactionType = 'Semua Transaksi';

  @override
  void initState() {
    super.initState();
    // Default mencakup seluruh periode data hasil ekstraksi BJB (Juni - Agustus 2026)
    _startDate = DateTime(2026, 6, 1);
    _endDate = DateTime(2026, 8, 31);
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
          _endDate = _startDate.add(const Duration(days: 30));
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field 1: Dari Tanggal
            const Text(
              'Dari Tanggal',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickStartDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDisplayDate(_startDate),
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF0083C9),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Field 2: Sampai Tanggal
            const Text(
              'Sampai Tanggal',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickEndDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDisplayDate(_endDate),
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF0083C9),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Field 3: Jenis Transaksi
            const Text(
              'Jenis Transaksi',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTransactionType,
                  isExpanded: true,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Color(0xFF475569),
                    size: 24,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Semua Transaksi',
                      child: Text('Semua Transaksi'),
                    ),
                    DropdownMenuItem(
                      value: 'Uang Masuk (Kredit)',
                      child: Text('Uang Masuk (Kredit)'),
                    ),
                    DropdownMenuItem(
                      value: 'Uang Keluar (Debit)',
                      child: Text('Uang Keluar (Debit)'),
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

            const SizedBox(height: 16),

            // Field 4: Email Input
            const Text(
              'Email',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
                decoration: const InputDecoration(
                  hintText: 'Input email',
                  hintStyle: TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Catatan Disclaimer (1:1 Sesuai Foto Referensi)
            const Text(
              '*) Data transaksi yang dapat ditampilkan adalah 3 Bulan terakhir sejak hari ini',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 11,
                color: Color(0xFF94A3B8),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '*) Data transaksi berdasarkan range hari maksimal 1 Bulan',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 11,
                color: Color(0xFF94A3B8),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '*) Untuk membuat file pdf mutasi rekening gunakan tanggal lahir anda dengan format ddmmyyyy (Tanggal Bulan Tahun lahir anda. Contoh: 06081980)',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 11,
                color: Color(0xFF94A3B8),
                height: 1.35,
              ),
            ),

            const SizedBox(height: 28),

            // Tombol Kuning BJB "Tampilkan" (1:1 Sesuai Foto Referensi)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onTampilkan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDB913), // Kuning BJB
                  foregroundColor: const Color(0xFF00588A), // Teks Biru Tua
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tampilkan',
                  style: TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00588A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
