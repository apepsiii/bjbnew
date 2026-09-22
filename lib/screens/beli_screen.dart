import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

/// Layar Beli 1:1 sesuai desain referensi beli.webp
class BeliScreen extends StatelessWidget {
  const BeliScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'Paket Data', 'asset': AppAssets.beliPaketData},
      {'title': 'Pulsa', 'asset': AppAssets.beliPulsa},
      {'title': 'E-Voucher', 'asset': AppAssets.beliEvoucher},
      {'title': 'Top Up\nE-wallet', 'asset': AppAssets.beliTopupEwallet},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Top Wavy Red Ribbon Header with Back Button
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  AppAssets.beliHeader,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  left: 12,
                  top: 40,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Baris 4 Kategori Pembelian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((item) {
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Layanan ${item['title']!.replaceAll('\n', ' ')} dipilih.',
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamily,
                              ),
                            ),
                            backgroundColor: const Color(0xFF0C385C),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                item['asset']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title']!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF003E66),
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
