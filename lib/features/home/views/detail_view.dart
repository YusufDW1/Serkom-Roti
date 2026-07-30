/// lib/features/home/views/detail_view.dart
///
/// Product detail screen with two CTA buttons:
/// "Pesan Langsung" (Direct Checkout) and "Keranjang" (Add to Cart).

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../models/bakery_item.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../utils/formatters.dart';

class DetailView extends StatelessWidget {
  final BakeryItem item;

  const DetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final cartCtrl = Get.put(CartController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero image placeholder
            Hero(
              tag: 'hero_${item.id}',
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppTheme.flour,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(item.category),
                      size: 56,
                      color: AppTheme.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product name
            Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              item.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.onSurfaceMedium,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),

            // Price
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceMedium,
                    ),
                  ),
                  Text(
                    item.price.toRupiah(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Dual CTA Buttons ──────────────────────
            Row(
              children: [
                // "Pesan Langsung" - Primary button (expanded)
                Expanded(
                  child: GetBuilder<CartController>(
                    init: cartCtrl,
                    builder: (ctrl) {
                      return ElevatedButton.icon(
                        onPressed: () async {
                          await homeCtrl.addToCart(item);
                          Get.toNamed('/cart');
                        },
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text('Pesan Langsung'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: AppTheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // "Keranjang" - Add to cart (secondary)
                GetBuilder<CartController>(
                  init: cartCtrl,
                  builder: (ctrl) {
                    return ElevatedButton(
                      onPressed: () async {
                        await homeCtrl.addToCart(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(
                            color: AppTheme.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(48, 48),
                      ),
                      child: const Icon(Icons.shopping_cart_checkout_rounded,
                          size: 24),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bread':
        return Icons.cookie_rounded;
      case 'Pastry':
        return Icons.bakery_dining_rounded;
      case 'Cake':
        return Icons.cake_rounded;
      case 'Snack':
        return Icons.local_offer_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }
}
