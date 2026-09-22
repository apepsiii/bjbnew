import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

/// Layar Bayar 1:1 sesuai desain referensi bayar.webp
class BayarScreen extends StatelessWidget {
  const BayarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'Ponsel', 'asset': AppAssets.bayarPonsel},
      {'title': 'Telepon', 'asset': AppAssets.bayarTelepon},
      {'title': 'Internet', 'asset': AppAssets.bayarInternet},
      {'title': 'BPJS', 'asset': AppAssets.bayarBpjs},
      {'title': 'TV Kabel', 'asset': AppAssets.bayarTvKabel},
      {'title': 'Multifinance', 'asset': AppAssets.bayarMultifinance},
      {'title': 'Tiket', 'asset': AppAssets.bayarTiket},
      {'title': 'PDAM', 'asset': AppAssets.bayarPdam},
      {'title': 'DPLK', 'asset': AppAssets.bayarDplk},
      {'title': 'Pajak /\nRetribusi', 'asset': AppAssets.bayarPajakRetribusi},
      {'title': 'Kartu Kredit', 'asset': AppAssets.bayarKartuKredit},
      {'title': 'Pendidikan', 'asset': AppAssets.bayarPendidikan},
      {'title': 'Rumah\nSakit', 'asset': AppAssets.bayarRumahSakit},
      {'title': 'Penerimaan\nNegara', 'asset': AppAssets.bayarPenerimaanNegara},
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
                  AppAssets.bayarHeader,
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

            const SizedBox(height: 16),

            // Grid 14 Kategori Pembayaran
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Layanan Pembayaran ${item['title']!.replaceAll('\n', ' ')} dipilih.',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamily,
                            ),
                          ),
                          backgroundColor: const Color(0xFF0C385C),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Card Icon Superellipse
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.asset(
                              item['asset']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Label Kategori
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: AppAssets.fontFamily,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF003E66),
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
