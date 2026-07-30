/// lib/app/bindings/auth_binding.dart
///
/// Binding for authentication-related screens (Login, Admin Dashboard).
/// Provides AuthController to the route.

import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
