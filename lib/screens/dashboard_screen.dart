import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import 'bayar_screen.dart';
import 'beli_screen.dart';
import 'manajemen_keuangan_screen.dart';
import 'login_screen.dart';

/// Layar Menu Utama (Dashboard) 1:1 sesuai desain context/design_reference/new/4main_menu_top_page.jpeg & scrolled.jpeg
class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = false;
  bool _isDigiCashVisible = false;
  int _selectedNavIndex = 0;

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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Konten Scrollable
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 90 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Biru BJB (~50% Tinggi Layar)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: topPadding + 8,
                    left: 18,
                    right: 18,
                    bottom: 40,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.headerDashboard),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: Status Dot Hijau & Search / Mic Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Status Hijau Online
                          Container(
                            width: 14,
                            height: 14,
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

                          // Tombol Bulat Search & Mic (Kanan Top)
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

                      const SizedBox(height: 28),

                      // Sapaan Nama Nasabah
                      Text(
                        '${widget.user.fullName}...',
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Loyalty Point Teks Murni
                      const Text(
                        'Loyalty Point',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

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

                      // Card 2: DigiCash (Seragam dengan Card 1 di atasnya)
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

                // White Container Menu Grid Renggang & Longgar dengan Overlay (+1 Overlay)
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 22, 12, 28),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                    children: [
                      // Grid 15 Menu Items dengan Jarak Renggang Longgar
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 26,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.82,
                        children: [
                          // Row 1
                          _buildGridItem(
                            asset: AppAssets.iconMenuManajemenKeuangan,
                            label: 'Manajemen\nKeuangan',
                            onTap: _openManajemenKeuangan,
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuTransfer,
                            label: 'Transfer',
                            onTap: _openManajemenKeuangan,
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuBayar,
                            label: 'Bayar',
                            onTap: _openBayarScreen,
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuBeli,
                            label: 'Beli',
                            onTap: _openBeliScreen,
                          ),

                          // Row 2
                          _buildGridItem(
                            asset: AppAssets.iconMenuCardless,
                            label: 'Cardless',
                            onTap: () => _showToast('Layanan Cardless BJB'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuBukaRekening,
                            label: 'Buka\nRekening',
                            onTap: () => _showToast('Buka Rekening BJB'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuPinjamanAsn,
                            label: 'Pinjaman\nASN',
                            onTap: () => _showToast('Pinjaman ASN (KGB Pisan)'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuTandamata,
                            label: 'bjb\nTandamata\nRencana',
                            onTap: () => _showToast('bjb Tandamata Rencana'),
                          ),

                          // Row 3
                          _buildGridItem(
                            asset: AppAssets.iconMenuDonasi,
                            label: 'Donasi',
                            onTap: () => _showToast('Layanan Donasi BJB'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconTsamsat,
                            label: 'T-Samsat',
                            onTap: () => _showToast('Layanan T-Samsat BJB'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuDeposito,
                            label: 'bjb\nDeposito',
                            onTap: () => _showToast('Layanan bjb Deposito'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconMenuLainnya,
                            label: 'Menu\nLainnya',
                            onTap: () => _showToast('Menu Lainnya BJB'),
                          ),

                          // Row 4 (Tampil saat di-scroll ke bawah 1:1 sesuai gambar scrolled.jpeg)
                          _buildGridItem(
                            asset: AppAssets.iconDigiloan,
                            label: 'Digiloan',
                            onTap: () => _showToast('Layanan Digiloan BJB'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconWebLelang,
                            label: 'bjb Lelang',
                            onTap: () => _showToast('Layanan bjb Lelang'),
                          ),
                          _buildGridItem(
                            asset: AppAssets.iconDplk,
                            label: 'DPLK',
                            onTap: () => _showToast('Layanan DPLK BJB'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 20),

                      // Seksi Favorit saat di-scroll ke bawah
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Favorit',
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Placeholder Lingkaran Favorit Putus-putus
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF94A3B8),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF94A3B8),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              ],
            ),
          ),

          // Floating Logo Tammy "Panggil Tami" di Kanan Bawah
          Positioned(
            right: 14,
            bottom: 74 + bottomPadding,
            child: GestureDetector(
              onTap: () {
                _showToast('Halo! Saya Tami, asisten virtual bank bjb.');
              },
              child: Image.asset(
                AppAssets.logoTammyFloating,
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bottom Navigation Bar Presisi
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
      height: 52,
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
          Image.asset(
            iconAsset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),

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

  Widget _buildGridItem({
    required String asset,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2EDF8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0075B5).withValues(alpha: 0.05),
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
            maxLines: 3,
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
    );
  }

  Widget _buildBottomNavigationBar(double bottomPadding) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bar Navigasi Putih
            Container(
              height: 58,
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
                children: [
                  // Item 1: Inbox
                  Expanded(
                    child: _buildNavItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Inbox',
                      isSelected: _selectedNavIndex == 0,
                      onTap: () {
                        setState(() => _selectedNavIndex = 0);
                        _showToast('Layanan Inbox BJB');
                      },
                    ),
                  ),
                  // Item 2: Favorit
                  Expanded(
                    child: _buildNavItem(
                      icon: Icons.favorite_border_rounded,
                      label: 'Favorit',
                      isSelected: _selectedNavIndex == 1,
                      onTap: () {
                        setState(() => _selectedNavIndex = 1);
                        _showToast('Layanan Favorit BJB');
                      },
                    ),
                  ),

                  // Space untuk Floating QR Button di tengah
                  const SizedBox(width: 68),

                  // Item 3: Setting
                  Expanded(
                    child: _buildNavItem(
                      icon: Icons.settings_outlined,
                      label: 'Setting',
                      isSelected: _selectedNavIndex == 2,
                      onTap: () {
                        setState(() => _selectedNavIndex = 2);
                        _showToast('Pengaturan BJB DIGI');
                      },
                    ),
                  ),
                  // Item 4: Keluar
                  Expanded(
                    child: _buildNavItem(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      isSelected: _selectedNavIndex == 3,
                      onTap: _showLogoutDialog,
                    ),
                  ),
                ],
              ),
            ),

            // Floating QR Button di Tengah
            Positioned(
              top: -12,
              child: GestureDetector(
                onTap: () => _showToast('Buka Pembayaran QRIS BJB'),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AppAssets.iconQr,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? const Color(0xFF0083C9) : const Color(0xFF64748B);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppAssets.fontFamily,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
