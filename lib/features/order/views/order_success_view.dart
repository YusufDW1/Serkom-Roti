/// lib/features/order/views/order_success_view.dart
///
/// Beautiful success screen shown after successful checkout.
/// Shows a Lottie checkmark animation, confirmation text, and summary.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation placeholder (Lottie)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(height: 24),

              // Success title
              Text(
                'Pesanan Berhasil!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                  letterSpacing: -0.01,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Pesanan Anda telah dikirim ke kami.\n'
                'Koordinat GPS telah dicatat.\n'
                'Tim kami akan segera menghubungi Anda.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.onSurfaceMedium,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Continue shopping button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}