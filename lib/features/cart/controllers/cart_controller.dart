/// lib/features/cart/controllers/cart_controller.dart
///
/// GetX controller for the Cart screen.
/// Manages cart items read from SQLite, quantities, and checkout.

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../services/database_helper.dart';
import '../../cart/models/cart_item.dart';
import '../../../services/location_service.dart';
import '../../../services/firebase_service.dart';
import '../../../features/order/models/order_model.dart';

class CartController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirebaseService _firebaseService = FirebaseService();

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble total = 0.0.obs;
  final RxBool isCheckoutLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await _dbHelper.getAllItems();
    cartItems.value = items.map((e) => CartItemModel.fromMap(e)).toList();
    total.value = await _dbHelper.getTotal();
  }

  Future<void> refreshCart() async {
    await _loadCart();
  }

  Future<void> updateQuantity(String productId, int newQty) async {
    await _dbHelper.updateQuantity(productId, newQty);
    await _loadCart();
  }

  Future<void> removeItem(String productId) async {
    await _dbHelper.deleteItem(productId);
    await _loadCart();
  }

  Future<void> deleteItem(String productId) async {
    await _dbHelper.deleteItem(productId);
    await _loadCart();
  }

  Future<void> clearCart() async {
    await _dbHelper.clearCart();
    cartItems.clear();
    total.value = 0.0;
  }

  Future<(double latitude, double longitude)> _resolveCheckoutCoordinates() async {
    final service = LocationService();

    if (!await service.isLocationEnabled()) {
      final enabled = await Get.dialog<bool>(
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Lokasi mati'),
              content: const Text('Hidupkan layanan lokasi agar checkout bisa mencatat alamat pengiriman.'),
              actions: [
                TextButton(onPressed: () => Get.back(result: false), child: const Text('Tutup')),
                ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Buka Pengaturan')),
              ],
            ),
          ) ??
          false;

      if (!enabled) {
        throw StateError('Layanan lokasi belum diaktifkan.');
      }
    }

    final granted = await service.requestPermission();
    if (!granted) {
      final openSettings = await Get.dialog<bool>(
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Izin lokasi diperlukan'),
              content: const Text('Berikan akses lokasi agar pesanan Anda bisa diantar ke alamat yang tepat.'),
              actions: [
                TextButton(onPressed: () => Get.back(result: false), child: const Text('Tutup')),
                ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Buka Pengaturan')),
              ],
            ),
          ) ??
          false;

      if (openSettings) {
        await Geolocator.openAppSettings();
      }

      throw StateError('Izin lokasi ditolak. Izinkan akses lokasi lalu coba checkout lagi.');
    }

    final coords = await service.getCoordinates();
    return (coords.$1, coords.$2);
  }

  /// Completes checkout: gets GPS location, submits to Firebase, clears cart.
  Future<bool> checkout(String customerName, String? customerId) async {
    if (cartItems.isEmpty) {
      errorMessage.value = 'Keranjang kosong';
      return false;
    }

    isCheckoutLoading.value = true;
    errorMessage.value = '';

    try {
      final coords = await _resolveCheckoutCoordinates();

      final items = cartItems.map((e) => OrderItem(
            productId: e.productId,
            name: e.name,
            price: e.price,
            quantity: e.quantity,
          )).toList();

      final order = OrderModel(
        customerName: customerName,
        customerId: customerId,
        items: items,
        total: total.value,
        latitude: coords.$1,
        longitude: coords.$2,
        status: 'pending',
      );

      // 4. Submit to Firebase
      await _firebaseService.createOrder(order);

      // 5. Clear local cart
      await clearCart();

      isCheckoutLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Checkout gagal: $e';
      isCheckoutLoading.value = false;
      return false;
    }
  }
}