// lib/features/auth/controllers/auth_controller.dart
//
// GetX controller managing authentication state with Firebase Auth.
// Handles register, login, logout, email verification,
// password/email updates, and role-based routing.

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isEmailVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  // ── Check if user is already logged in ──────────────────
  void _checkCurrentUser() {
    final user = _authService.currentUser;
    if (user != null) {
      _loadUserData(user.uid);
    }
  }

  // ── Load user data from Firestore ───────────────────────
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        currentUser.value = UserModel(
          id: uid,
          name: data['name'] ?? '',
          role: data['role'] ?? 'customer',
        );
        isEmailVerified.value = _authService.isEmailVerified();
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat data pengguna';
    }
  }

  // ── Register new customer ──────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        isLoading.value = false;
        return true;
      }

      errorMessage.value = 'Registrasi gagal';
      isLoading.value = false;
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  // ── Login ───────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        currentUser.value = user;
        isEmailVerified.value = _authService.isEmailVerified();

        if (user.role == 'admin') {
          Get.offAllNamed('/admin');
        } else {
          if (!isEmailVerified.value) {
            Get.offAllNamed('/verify-email');
          } else {
            Get.offAllNamed('/home');
          }
        }
      } else {
        errorMessage.value = 'Login gagal';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Admin login (checks role in Firestore) ─────────────
  Future<void> adminLogin(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authService.adminLogin(email, password);

      if (user != null) {
        currentUser.value = user;
        Get.offAllNamed('/admin');
      } else {
        errorMessage.value = 'Login admin gagal';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ──────────────────────────────────────────────
  void logout() async {
    await _authService.logout();
    currentUser.value = null;
    isEmailVerified.value = false;
    Get.offAllNamed('/login');
  }

  // ── Send email verification ─────────────────────────────
  Future<void> sendEmailVerification() async {
    isLoading.value = true;
    try {
      await _authService.sendEmailVerification();
      errorMessage.value = 'Email verifikasi telah dikirim';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Update email ────────────────────────────────────────
  Future<bool> updateEmail(String newEmail) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authService.updateEmail(newEmail);
      errorMessage.value = 'Email berhasil diperbarui. Cek email verifikasi baru.';
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  // ── Update password ─────────────────────────────────────
  Future<bool> updatePassword(String newPassword) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authService.updatePassword(newPassword);
      errorMessage.value = 'Password berhasil diperbarui';
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  // ── Re-authenticate ─────────────────────────────────────
  Future<bool> reauthenticate(String password) async {
    try {
      await _authService.reauthenticate(password);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }
}
