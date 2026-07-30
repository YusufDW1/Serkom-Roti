// lib/features/order/controllers/order_controller.dart
//
// GetX controller for order-related screens (success, admin, history).
// Handles real-time order streams, cancellation, and status updates.

import 'package:get/get.dart';
import '../../../services/firebase_service.dart';
import '../../../features/order/models/order_model.dart';

class OrderController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> customerOrders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenOrders();
  }

  // ── Listen to all orders (Admin) ────────────────────────
  void _listenOrders() {
    _firebaseService.ordersSnapshot().listen((snapshot) {
      orders.value = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      isLoading.value = false;
    });
  }

  // ── Listen to customer orders ───────────────────────────
  void listenCustomerOrders(String customerId) {
    _firebaseService.customerOrdersSnapshot(customerId).listen((snapshot) {
      customerOrders.value = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      isLoading.value = false;
    });
  }

  // ── Cancel order (only if pending) ──────────────────────
  Future<bool> cancelOrder(String orderId) async {
    try {
      final success = await _firebaseService.cancelOrder(orderId);
      if (success) {
        // Remove from local list
        orders.removeWhere((o) => o.orderId == orderId);
        customerOrders.removeWhere((o) => o.orderId == orderId);
      }
      return success;
    } catch (e) {
      errorMessage.value = 'Gagal membatalkan pesanan: $e';
      return false;
    }
  }

  // ── Update order status (Admin) ────────────────────────
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firebaseService.updateOrderStatus(orderId, status);
    } catch (e) {
      errorMessage.value = 'Gagal memperbarui status: $e';
    }
  }
}
