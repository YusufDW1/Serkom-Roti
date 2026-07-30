/// lib/features/cart/views/cart_view.dart
///
/// Cart/Checkout screen. Displays accumulated items from SQLite.
/// Triggers GPS location request before finalizing checkout.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../services/auth_service.dart';
import '../../../utils/formatters.dart';
import '../../cart/models/cart_item.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge.count(
                count: controller.cartItems.length,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                if (controller.cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 64, color: AppTheme.cinnamon),
                        const SizedBox(height: 12),
                        Text(
                          'Keranjang masih kosong',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppTheme.onSurfaceMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Lanjutkan Belanja'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = controller.cartItems[index];
                    return _buildCartItemTile(cartItem, controller);
                  },
                );
              },
            ),
          ),

          // ── Bottom Checkout Bar ──────────────────
          _buildBottomBar(controller),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(
      CartItemModel item, CartController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.flour,
                borderRadius: BorderRadius.circular(10),
              ),
              child: item.imageUrl != null &&
                      item.imageUrl!.trim().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.imageUrl!.trim(),
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_rounded,
                                color: AppTheme.cinnamon, size: 24),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.cinnamon,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.image_rounded,
                      color: AppTheme.cinnamon, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item.price * item.quantity).toRupiah()} x${item.quantity}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppTheme.onSurfaceMedium,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      size: 20, color: AppTheme.primary),
                  tooltip: 'Kurangi',
                  onPressed: () => controller
                      .updateQuantity(item.productId, item.quantity - 1),
                ),
                Text(
                  '${item.quantity}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      size: 20, color: AppTheme.primary),
                  onPressed: () => controller
                      .updateQuantity(item.productId, item.quantity + 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 18, color: AppTheme.error),
              onPressed: () => controller.deleteItem(item.productId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(CartController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                Text(
                  controller.total.value.toRupiah(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isCheckoutLoading.value
                      ? null
                      : () => _handleCheckout(controller),
                  child: controller.isCheckoutLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckout(CartController controller) async {
    final nameCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await Get.dialog<String?>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Checkout'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Masukkan nama Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Lokasi akan diminta pada langkah berikutnya untuk pengiriman.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.onSurfaceMedium,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Batal'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isCheckoutLoading.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        Get.back(result: nameCtrl.text.trim());
                      }
                    },
              child: controller.isCheckoutLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Lanjutkan'),
            ),
          ),
        ],
      ),
    );

    if (result == null) return;

    final customerId = AuthService().currentUser?.uid;
    final success = await controller.checkout(result, customerId);

    if (success) {
      Get.offAndToNamed('/order-success');
    } else {
      Get.snackbar(
        'Gagal',
        controller.errorMessage.value.isEmpty
            ? 'Terjadi kesalahan'
            : controller.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error.withOpacity(0.1),
        colorText: AppTheme.error,
      );
    }
  }
}