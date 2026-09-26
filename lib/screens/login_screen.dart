import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

/// Layar Login 1:1 sesuai desain referensi 2login_page.jpeg & 3password_after_klik_login.jpeg
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _queryController = TextEditingController(text: 'aldi');
  String _savedFullName = 'ALDI FIRNANDO...';

  @override
  void initState() {
    super.initState();
    _loadSavedUser();
  }

  void _loadSavedUser() async {
    final saved = await ApiService.getRememberedUser();
    if (saved != null) {
      if (mounted) {
        setState(() {
          if (saved['username'] != null && saved['username']!.isNotEmpty) {
            _queryController.text = saved['username']!;
          }
          if (saved['fullName'] != null && saved['fullName']!.isNotEmpty) {
            _savedFullName = '${saved['fullName']!.toUpperCase()}...';
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _showPasswordDialog() async {
    final usernameInput = _queryController.text.trim().isEmpty ? 'aldi' : _queryController.text.trim();

    final UserModel? loggedInUser = await showDialog<UserModel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => _PasswordDialog(initialUsername: usernameInput),
    );

    if (mounted) {
      final targetUser = loggedInUser ?? UserModel.defaultUser;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardScreen(user: targetUser),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Header mengambil ~44% tinggi layar (1:1 Sesuai 2login_page.jpeg)
    final headerHeight = size.height * 0.44;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              // Top Header Biru BJB (~44% Tinggi Layar) 1:1 Sesuai Foto
              Container(
                width: double.infinity,
                height: headerHeight,
                padding: EdgeInsets.only(
                  top: topPadding + 8,
                  left: 20,
                  right: 20,
                  bottom: 24,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Pill: Cek saldo anda ︾
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF004B7A).withValues(alpha: 0.9),
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
                          SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),

                    // Middle Sapaan User: Halo, ALDI FIRNANDO...
                    Column(
                      children: [
                        const Text(
                          'Halo,',
                          style: TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _savedFullName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Card Form "Kamu mau melakukan transaksi?" 1:1 Sesuai Foto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kamu mau melakukan transaksi?',
                      style: TextStyle(
                        fontFamily: AppAssets.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Baris Input + Tombol Kuning "Go"
                    Row(
                      children: [
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

                        // Tombol Kuning "Go"
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

              // Bagian Bawah: Mascot Tammi + Pill "Login" 1:1 Sesuai Foto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Quick Action Button
                      Positioned(
                        left: 12,
                        bottom: 30,
                        child: GestureDetector(
                          onTap: _showPasswordDialog,
                          child: Column(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
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
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Quick\nAction',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamily,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00588A),
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Mascot Tammi
                      Positioned(
                        right: 12,
                        bottom: 0,
                        child: Image.asset(
                          AppAssets.tammi,
                          height: 230,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Floating Pill "Login"
                      Positioned(
                        right: 32,
                        bottom: 36,
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
                                  size: 17,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamily,
                                    fontSize: 14,
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

              SizedBox(height: bottomPadding + 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal Dialog Password (1:1 Sesuai Gambar Referensi Terbaru)
class _PasswordDialog extends StatefulWidget {
  final String initialUsername;
  const _PasswordDialog({required this.initialUsername});

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final TextEditingController _passController = TextEditingController(text: '123456');
  bool _obscureText = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  void _onMasuk() async {
    setState(() => _isAuthenticating = true);

    final username = widget.initialUsername.isEmpty ? 'aldi' : widget.initialUsername;
    final password = _passController.text.trim().isEmpty ? '123456' : _passController.text.trim();

    final user = await ApiService.login(username, password);

    if (mounted) {
      setState(() => _isAuthenticating = false);
      Navigator.of(context).pop(user);
    }
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
            // Header Tutup dengan ikon silang biru
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
                        color: const Color(0xFF0083C9),
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
                            fontSize: 13.5,
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
                  const SizedBox(height: 6),
                  const Text(
                    'Lupa Password',
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0083C9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tombol Masuk Berwarna Kuning BJB (1:1 Sesuai Foto Referensi)
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
              child: ElevatedButton(
                onPressed: _isAuthenticating ? null : _onMasuk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDB913), // Warna Kuning BJB
                  foregroundColor: const Color(0xFF00588A), // Teks Biru Tua
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: _isAuthenticating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF00588A),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Masuk',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00588A),
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
