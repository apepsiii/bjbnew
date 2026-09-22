import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';

/// Layar Login 1:1 sesuai desain referensi 2login_page.jpeg & 3password_after_klik_login.jpeg
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _showPasswordDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => const _PasswordDialog(),
    );
    if (result == true && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(user: UserModel.defaultUser),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height - bottomPadding,
          child: Column(
            children: [
              // Top Header Biru BJB dengan Sapaan MUHAMAD SAEPURAH...
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: topPadding + 12,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.headerQuickAccess),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pill Cek saldo anda ︾
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00588A).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cek saldo anda',
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 38),

                    // Sapaan Nasabah
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Halo,',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MUHAMAD SAEPURAH...',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Kontainer Pertanyaan & Input bar transaksi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kamu mau melakukan transaksi?',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Baris Input + Tombol Go
                    Row(
                      children: [
                        // Field Input rounded light blue
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9ECFA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _queryController,
                                    style: const TextStyle(
                                      fontFamily: AppAssets.fontFamily,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E293B),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onSubmitted: (_) => _showPasswordDialog(),
                                  ),
                                ),
                                // Dropdown & Clear icons
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4A5568),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _queryController.clear(),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFA0AEC0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tombol Kuning BJB "Go"
                        GestureDetector(
                          onTap: _showPasswordDialog,
                          child: Container(
                            height: 48,
                            width: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDB913),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFDB913)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Go',
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bagian Bawah: Quick Action + Mascot Tammi + Pill "Login"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 300,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Quick Action Button di Kiri Bawah
                      Positioned(
                        left: 12,
                        bottom: 40,
                        child: GestureDetector(
                          onTap: _showPasswordDialog,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0094E8),
                                      Color(0xFF0066B3),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0066B3)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Quick\nAction',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00588A),
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Mascot Tammi di Kanan
                      Positioned(
                        right: 12,
                        bottom: 0,
                        child: Image.asset(
                          AppAssets.tammi,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Floating Pill "Login" di depan pinggang Tammi (1:1 sesuai 2login_page.jpeg)
                      Positioned(
                        right: 32,
                        bottom: 48,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _showPasswordDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F3FD),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.home_rounded,
                                  color: Color(0xFF00588A),
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamily,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF00588A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal Dialog Password 1:1 sesuai 3password_after_klik_login.jpeg
class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog();

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  void _onMasuk() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Tutup dengan ikon silang di kanan
            Padding(
              padding: const EdgeInsets.only(top: 14, right: 14, bottom: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Color(0xFF0083C9),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Tutup',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0083C9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Input Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Center(
                      child: TextField(
                        controller: _passController,
                        obscureText: _obscureText,
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password Anda',
                          hintStyle: const TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF0083C9),
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        onSubmitted: (_) => _onMasuk(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Teks Lupa Password
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Lupa Password',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0083C9),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Tombol Kuning "Masuk"
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onMasuk,
              child: Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDB913),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 15.5,
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
