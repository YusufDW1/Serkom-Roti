/// lib/features/auth/views/verify_email_view.dart
///
/// Email verification screen shown after registration.
/// Shows instructions and a button to resend verification email.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verifikasi Email',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kami telah mengirimkan email verifikasi ke akun Anda. '
                'Silakan cek inbox (dan folder spam) untuk memverifikasi email.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.sendEmailVerification(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Kirim Ulang Email Verifikasi'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: const Text(
                  'Lewati verifikasi (dev mode)',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.isEmailVerified.value = AuthService().isEmailVerified();
                  if (controller.isEmailVerified.value) {
                    Get.offAllNamed('/home');
                  } else {
                    Get.snackbar(
                      'Belum Terverifikasi',
                      'Email belum diverifikasi. Silakan cek kembali.',
                      backgroundColor: AppTheme.error.withOpacity(0.1),
                      colorText: AppTheme.error,
                    );
                  }
                },
                child: const Text('Sudah diverifikasi? Lanjutkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}