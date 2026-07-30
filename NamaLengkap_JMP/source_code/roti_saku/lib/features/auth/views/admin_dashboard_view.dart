/// lib/features/auth/views/admin_dashboard_view.dart
///
/// Admin Dashboard showing real-time incoming orders from Firestore.
/// Displays GPS coordinates of each customer order.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../order/controllers/order_controller.dart';
import '../../order/models/order_model.dart';
import '../../order/widgets/order_card.dart';
import '../../../theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final orderCtrl = Get.put(OrderController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Roti Saku - Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => authCtrl.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (orderCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        final orders = orderCtrl.orders;

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 64, color: AppTheme.cinnamon),
                const SizedBox(height: 12),
                Text(
                  'Belum ada pesanan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppTheme.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            orderCtrl.isLoading.value = true;
            await Future.delayed(const Duration(milliseconds: 500));
            orderCtrl.isLoading.value = false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                isAdmin: true,
                actionRow: _buildAdminActions(order, orderCtrl),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildAdminActions(OrderModel order, OrderController orderCtrl) {
    if (order.status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => orderCtrl.updateOrderStatus(order.orderId!, 'processing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Proses'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => orderCtrl.updateOrderStatus(order.orderId!, 'completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Selesai'),
            ),
          ),
        ],
      );
    }

    if (order.status == 'processing') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => orderCtrl.updateOrderStatus(order.orderId!, 'completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Tandai Selesai'),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
