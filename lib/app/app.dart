/// lib/app/app.dart
///
/// Root application widget for Roti Saku.
/// Configures GetMaterialApp with theme, routing, and initial binding.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_pages.dart';
import 'app_routes.dart';
import '../theme/app_theme.dart';
import 'bindings/initial_binding.dart';

class RotiSakuApp extends StatelessWidget {
  const RotiSakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Roti Saku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.login,
      getPages: AppRoutes.routes,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}