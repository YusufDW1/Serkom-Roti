/// lib/features/order/views/order_history_view.dart
///
/// Customer order history screen.
/// Shows past orders with cancel button (only for pending orders).

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../widgets/order_card.dart';
import '../../../services/auth_service.dart';

class OrderHistoryView extends StatelessWidget {
  OrderHistoryView({super.key});

  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final customerId = AuthService().currentUser?.uid ?? '';
    if (customerId.isNotEmpty) {
      controller.listenCustomerOrders(customerId);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        final orders = controller.customerOrders;

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 64, color: AppTheme.cinnamon),
                const SizedBox(height: 12),
                Text(
                  'Belum ada riwayat pesanan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppTheme.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              actionRow: _buildCancelAction(order, controller),
            );
          },
        );
      }),
    );
  }

  Widget _buildCancelAction(OrderModel order, OrderController controller) {
    if (order.status != 'pending') return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () => _confirmCancel(order.orderId!, controller),
        icon: Icon(Icons.cancel_outlined, size: 16, color: AppTheme.error),
        label: Text('Batalkan Pesanan'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.error,
          side: BorderSide(color: AppTheme.error),
          textStyle: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
  }

  void _confirmCancel(String orderId, OrderController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text('Pesanan yang dibatalkan tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.cancelOrder(orderId);
              Get.back();
              if (success) {
                Get.snackbar(
                  'Berhasil',
                  'Pesanan berhasil dibatalkan',
                  backgroundColor: AppTheme.success.withValues(alpha: 0.15),
                  colorText: AppTheme.success,
                );
              } else {
                Get.snackbar(
                  'Gagal',
                  'Hanya pesanan dengan status pending yang bisa dibatalkan',
                  backgroundColor: AppTheme.error.withValues(alpha: 0.15),
                  colorText: AppTheme.error,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );
  }
}