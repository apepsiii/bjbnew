import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_assets.dart';
import '../models/user_model.dart';
import 'mutasi_rekening_form_screen.dart';

/// Layar Manajemen Keuangan 1:1 sesuai 6, 7, 8
class ManajemenKeuanganScreen extends StatefulWidget {
  final UserModel user;

  const ManajemenKeuanganScreen({super.key, required this.user});

  @override
  State<ManajemenKeuanganScreen> createState() =>
      _ManajemenKeuanganScreenState();
}

class _ManajemenKeuanganScreenState extends State<ManajemenKeuanganScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAction = 'Mini Statement';
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectAction(String action) {
    setState(() {
      _selectedAction = action;
      _isDropdownOpen = false;
    });

    if (action == 'Mutasi Rekening') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MutasiRekeningFormScreen(user: widget.user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final liveTimeString = DateFormat('dd/MM/yyyy\nHH:mm:ss').format(now);
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    final formattedBalance = formatter.format(widget.user.balance);

    return Scaffold(
      backgroundColor: const Color(0xFF0083C9),
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
          'Manajemen Keuangan',
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Tab Bar: Tabungan, DigiCash, Investasi, Pinjaman
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF00588A),
              unselectedLabelColor: const Color(0xFF4A5568),
              indicatorColor: const Color(0xFF0083C9),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Tabungan'),
                Tab(text: 'DigiCash'),
                Tab(text: 'Investasi'),
                Tab(text: 'Pinjaman'),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab Tabungan (1:1 sesuai 6manajemen_keuangan_page.jpeg)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Tabungan Tandamata Sertifikasi Guru
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Logo Bank BJB & Nominal IDR
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Logo bank bjb
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.logoDigiSmb,
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'bank bjb',
                                        style: TextStyle(
                                          fontFamily: AppAssets.fontFamily,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF00588A),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Saldo IDR 107.120,00 Available
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'IDR $formattedBalance',
                                        style: const TextStyle(
                                          fontFamily: AppAssets.fontFamily,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Available',
                                        style: TextStyle(
                                          fontFamily: AppAssets.fontFamily,
                                          fontSize: 12.5,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Nama Produk Tabungan
                              Text(
                                widget.user.accountType,
                                style: const TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Nomor Rekening
                              Text(
                                widget.user.accountNumber,
                                style: const TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Dropdown Mini Statement / Mutasi Rekening (1:1 sesuai 6, 7, 8)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDropdownOpen = !_isDropdownOpen;
                                  });
                                },
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6EBF8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedAction,
                                        style: const TextStyle(
                                          fontFamily: AppAssets.fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF00588A),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xFF00588A),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Menu Popup Dropdown jika terbuka (1:1 sesuai 7)
                              if (_isDropdownOpen) ...[
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FC),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            _onSelectAction('Mini Statement'),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            'Mini Statement',
                                            style: TextStyle(
                                              fontFamily: AppAssets.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF00588A),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFD6EBF8),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            _onSelectAction('Mutasi Rekening'),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            'Mutasi Rekening',
                                            style: TextStyle(
                                              fontFamily: AppAssets.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF00588A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Tombol Kuning "Tabungan Lainnya"
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Menampilkan daftar tabungan lainnya...',
                                ),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDB913),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFDB913)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Tabungan Lainnya',
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

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Tab Lainnya
                  const Center(child: Text('Layanan DigiCash')),
                  const Center(child: Text('Layanan Investasi')),
                  const Center(child: Text('Layanan Pinjaman')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
