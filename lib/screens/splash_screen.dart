import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import 'login_screen.dart';

/// Layar Splash Dua Tahap: splash_screen_new.png disusul launcher_background.png
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _phase = 0; // 0: splash_screen_new.png, 1: launcher_background.png
  Timer? _timer1;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();

    // Tahap 1 -> Tahap 2 (launcher_background.png) setelah 1.8 detik
    _timer1 = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _phase = 1;
        });
      }
    });

    // Tahap 2 -> LoginScreen setelah 3.6 detik
    _timer2 = Timer(const Duration(milliseconds: 3600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0083C9),
      body: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: _phase == 0
              ? Image.asset(
                  AppAssets.splashScreenNew,
                  key: const ValueKey(0),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.asset(
                  AppAssets.launcherBackground,
                  key: const ValueKey(1),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      ),
    );
  }
}
