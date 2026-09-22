import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import 'bayar_screen.dart';
import 'beli_screen.dart';
import 'manajemen_keuangan_screen.dart';
import 'login_screen.dart';

/// Layar Menu Utama (Dashboard) 1:1 sesuai desain context/design_reference/new/main_menu_fix.png
class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = false;
  bool _isDigiCashVisible = false;
  int _selectedTabIndex = 0;

  void _openManajemenKeuangan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManajemenKeuanganScreen(user: widget.user),
      ),
    );
  }

  void _openBayarScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BayarScreen(),
      ),
    );
  }

  void _openBeliScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BeliScreen(),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0C385C),
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi DIGI bank bjb?',
          style: TextStyle(fontFamily: AppAssets.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0083C9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppAssets.fontFamily),
        ),
        backgroundColor: const Color(0xFF00588A),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    final formattedBalance = formatter.format(widget.user.balance);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Konten Scrollable
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 84 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Biru BJB dengan header_dashboard.png (1:1 main_menu_fix.png)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: topPadding + 6,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.headerDashboard),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: Status Dot Hijau (kiri) & Search / Mic (kanan)
                      // Logo DIGI bank bjb ada di tengah pada header_dashboard.png
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Status Hijau Online dengan outer halo
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF4CD964).withValues(alpha: 0.35),
                            ),
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF34C759),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          // Tombol Bulat Search & Mic (Kanan)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showToast('Pencarian Menu BJB'),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    color: Color(0xFF2C3E50),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showToast('Voice Command BJB'),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.mic_none_rounded,
                                    color: Color(0xFF2C3E50),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 52),

                      // Sapaan Nasabah (1:1 sesuai main_menu_fix.png)
                      const Text(
                        'MUHAMAD SAEPURAH...',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Baris Poin & Info Program
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left: 1,455 Point + Pill Tukar
                          Row(
                            children: [
                              const Text(
                                '1,455 Point',
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showToast('Tukar Point BJB'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.sync_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Tukar',
                                        style: TextStyle(
                                          fontFamily: AppAssets.fontFamily,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Right: 0 Poin Undian & Info Program
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '0 Poin Undian',
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              GestureDetector(
                                onTap: () => _showToast('Info Program Undian BJB'),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Info Program',
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamily,
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Card 1: Rekening Tabungan Utama (0157902441103)
                      _buildAccountCard(
                        iconAsset: AppAssets.iconCardTabungan,
                        accountTitle: widget.user.accountNumber,
                        balanceText: _isBalanceVisible
                            ? 'IDR $formattedBalance'
                            : 'IDR ********',
                        isBalanceVisible: _isBalanceVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        onTapChevron: _openManajemenKeuangan,
                      ),

                      const SizedBox(height: 10),

                      // Card 2: DigiCash (085759247656)
                      _buildAccountCard(
                        iconAsset: AppAssets.iconCardDigicash,
                        accountTitle: '085759247656',
                        balanceText: _isDigiCashVisible
                            ? 'IDR 0,00'
                            : 'IDR ********',
                        isBalanceVisible: _isDigiCashVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isDigiCashVisible = !_isDigiCashVisible;
                          });
                        },
                        onTapChevron: () => _showToast('Layanan DigiCash BJB'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // White Card Menu 12 Grid (1:1 sesuai main_menu_fix.png)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 22, 8, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          // Baris 1: Manajemen Keuangan, Transfer, Bayar, Beli
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMenuItem(
                                asset: AppAssets.iconMenuManajemenKeuangan,
                                label: 'Manajemen\nKeuangan',
                                onTap: _openManajemenKeuangan,
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuTransfer,
                                label: 'Transfer',
                                onTap: _openManajemenKeuangan,
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuBayar,
                                label: 'Bayar',
                                onTap: _openBayarScreen,
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuBeli,
                                label: 'Beli',
                                onTap: _openBeliScreen,
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Baris 2: Cardless, Buka Rekening, bjb Deposito, bjb Tandamata
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMenuItem(
                                asset: AppAssets.iconMenuCardless,
                                label: 'Cardless',
                                onTap: () => _showToast('Layanan Cardless BJB'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuBukaRekening,
                                label: 'Buka\nRekening',
                                onTap: () => _showToast('Layanan Buka Rekening BJB'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuDeposito,
                                label: 'bjb\nDeposito',
                                onTap: () => _showToast('Layanan bjb Deposito'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuTandamata,
                                label: 'bjb\nTandamata',
                                onTap: () => _showToast('Layanan bjb Tandamata'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Baris 3: Flip, Donasi, Collect Dana, Pinjaman ASN
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMenuItem(
                                asset: AppAssets.iconMenuFlip,
                                label: 'Flip',
                                onTap: () => _showToast('Layanan Flip BJB'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuDonasi,
                                label: 'Donasi',
                                onTap: () => _showToast('Layanan Donasi BJB'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuCollectDana,
                                label: 'Collect\nDana',
                                onTap: () => _showToast('Layanan Collect Dana BJB'),
                              ),
                              _buildMenuItem(
                                asset: AppAssets.iconMenuPinjamanAsn,
                                label: 'Pinjaman\nASN',
                                onTap: () => _showToast('Layanan Pinjaman ASN (KGB Pisan)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Floating Logo Tammy di Kanan Bawah (persis di atas navbar)
          Positioned(
            right: 14,
            bottom: 64 + bottomPadding,
            child: GestureDetector(
              onTap: () {
                _showToast('Halo! Saya Tami, asisten virtual bank bjb.');
              },
              child: Image.asset(
                AppAssets.logoTammyFloating,
                width: 68,
                height: 68,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Floating Bottom Navigation Bar (1:1 sesuai main_menu_fix.png)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavigationBar(bottomPadding),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard({
    required String iconAsset,
    required String accountTitle,
    required String balanceText,
    required bool isBalanceVisible,
    required VoidCallback onToggleVisibility,
    required VoidCallback onTapChevron,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          const SizedBox(width: 10),
          // Icon Kartu (power / digi)
          Image.asset(
            iconAsset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),

          // Nomor & Saldo IDR
          Expanded(
            child: GestureDetector(
              onTap: onTapChevron,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountTitle,
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    balanceText,
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Eye toggle
          IconButton(
            icon: Icon(
              isBalanceVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFF475569),
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),

          // Yellow chevron button di sisi paling kanan
          GestureDetector(
            onTap: onTapChevron,
            child: Container(
              width: 36,
              height: double.infinity,
              color: const Color(0xFFFDB913),
              child: const Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF1E293B),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String asset,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2EDF8),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0075B5).withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(9),
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A5F),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(double bottomPadding) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 72,
        child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.inbox_outlined, 'Inbox'),
                _buildNavItem(1, Icons.favorite_border_rounded, 'Favorit'),
                const SizedBox(width: 48), // Ruang untuk center QRIS
                _buildNavItem(2, Icons.settings_outlined, 'Setting'),
                _buildNavItem(3, Icons.logout_rounded, 'Keluar', isLogout: true),
              ],
            ),
          ),

          // Tombol Lingkaran Pink/Red QRIS di Tengah
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => _showToast('QRIS Scanner Bank BJB'),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8B6B9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B2B38).withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Color(0xFF571E21),
                    size: 26,
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

  Widget _buildNavItem(int index, IconData icon, String label,
      {bool isLogout = false}) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () {
        if (isLogout) {
          _showLogoutDialog();
        } else {
          setState(() => _selectedTabIndex = index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? const Color(0xFF0075C9) : const Color(0xFF64748B),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppAssets.fontFamily,
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0075C9) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
