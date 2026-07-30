// lib/services/auth_service.dart
//
// Firebase Authentication service with role-based access.
// Manages user registration, login, email verification,
// password/email updates, and role management via Firestore.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/auth/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Register new customer ──────────────────────────────
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // Update display name
      await user.updateDisplayName(name);

      // Send email verification
      await user.sendEmailVerification();

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        id: user.uid,
        name: name,
        role: 'customer',
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Login with email/password ──────────────────────────
  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // Check if user is admin via Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final role = doc.exists ? (doc.data()!['role'] ?? 'customer') : 'customer';

      return UserModel(
        id: user.uid,
        name: user.displayName ?? email,
        role: role,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Admin login (hardcoded for demo) ───────────────────
  /// Admin credentials are checked against Firestore.
  /// To set up an admin: create a user in Firebase Auth,
  /// then set role='admin' in Firestore users collection.
  Future<UserModel?> adminLogin(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // Verify admin role
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists || doc.data()!['role'] != 'admin') {
        await _auth.signOut();
        throw Exception('Access denied: admin role required');
      }

      return UserModel(
        id: user.uid,
        name: user.displayName ?? email,
        role: 'admin',
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Logout ──────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Check if user is logged in ──────────────────────────
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // ── Get current user ────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Check email verification ────────────────────────────
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // ── Send email verification ─────────────────────────────
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // ── Update email ────────────────────────────────────────
  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await user.updateEmail(newEmail);
      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
      // Send verification for new email
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Update password ─────────────────────────────────────
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Re-authenticate (for sensitive operations) ──────────
  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user logged in');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Handle Firebase Auth exceptions ─────────────────────
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter)';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'requires-recent-login':
        return 'Silakan login ulang untuk operasi ini';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
