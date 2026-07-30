/// lib/features/order/widgets/order_card.dart
///
/// Shared order card used by customer order history and admin dashboard.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../order/models/order_model.dart';
import '../../../utils/formatters.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isAdmin;
  final Widget actionRow;

  const OrderCard({
    super.key,
    required this.order,
    this.isAdmin = false,
    required this.actionRow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pesanan #${order.orderId ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 12),

            // Customer name
            Row(
              children: [
                Icon(Icons.person_outline,
                    size: 16, color: AppTheme.onSurfaceMedium),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.customerName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Items
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        item.subtotal.toRupiah(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                )),

            const Divider(height: 24, color: AppTheme.cinnamon),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  order.total.toRupiah(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // GPS Coordinates
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: AppTheme.onSurfaceMedium),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'GPS: ${order.latitude.toStringAsFixed(4)}, ${order.longitude.toStringAsFixed(4)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            actionRow,
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending
            ? AppTheme.secondary.withValues(alpha: 0.18)
            : AppTheme.success.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPending ? AppTheme.secondaryDark : AppTheme.success,
        ),
      ),
    );
  }
}
