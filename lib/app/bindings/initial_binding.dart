/// lib/app/bindings/initial_binding.dart
///
/// Root-level binding that initializes all core services
/// (LocationService, DatabaseHelper, AuthService, FirebaseService)
/// so they are available throughout the app via Get.find<T>().

import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
import '../../services/location_service.dart';
import '../../services/firebase_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseHelper>(() => DatabaseHelper());
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<FirebaseService>(() => FirebaseService());
  }
}
