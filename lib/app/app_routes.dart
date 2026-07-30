/// lib/app/app_routes.dart
///
/// GetX route configuration for Roti Saku app.
/// Maps AppPages constants to views with their respective Bindings.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/views/admin_dashboard_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/profile_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/auth/views/verify_email_view.dart';
import '../features/cart/bindings/cart_binding.dart';
import '../features/cart/views/cart_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/models/bakery_item.dart';
import '../features/home/views/detail_view.dart';
import '../features/home/views/home_view.dart';
import '../features/order/bindings/order_binding.dart';
import '../features/order/views/order_history_view.dart';
import '../features/order/views/order_success_view.dart';
import 'app_pages.dart';

class AppRoutes {
  static final routes = <GetPage>[
    GetPage(
      name: AppPages.login,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.verifyEmail,
      page: () => VerifyEmailView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.detail,
      page: () {
        final args = Get.arguments;
        if (args is BakeryItem) {
          return DetailView(item: args);
        }
        Get.back();
        Future.microtask(() => Get.snackbar(
              'Gagal',
              'Data produk tidak valid',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade50,
              colorText: Colors.red.shade900,
            ));
        return const SizedBox.shrink();
      },
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.admin,
      page: () => const AdminDashboardView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPages.profile,
      page: () => ProfileView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.orderHistory,
      page: () => OrderHistoryView(),
      binding: OrderBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPages.orderSuccess,
      page: () => const OrderSuccessView(),
      binding: OrderBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
