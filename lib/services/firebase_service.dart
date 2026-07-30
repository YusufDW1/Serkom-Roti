// lib/services/firebase_service.dart
//
// Firebase Firestore operations for order management.
// Creates orders, listens to real-time order updates,
// and handles order cancellation.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/order/models/order_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _ordersCollection = 'orders';

  // ── Create Order ────────────────────────────────────────
  Future<String> createOrder(OrderModel order) async {
    final docRef = await _firestore.collection(_ordersCollection).add({
      'customerName': order.customerName,
      'customerId': order.customerId,
      'items': order.items.map((item) => item.toMap()).toList(),
      'total': order.total,
      'latitude': order.latitude,
      'longitude': order.longitude,
      'status': order.status,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // ── Stream Orders (Admin real-time) ─────────────────────
  Stream<QuerySnapshot> ordersSnapshot() {
    return _firestore
        .collection(_ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ── Stream Orders by Customer ───────────────────────────
  Stream<QuerySnapshot> customerOrdersSnapshot(String customerId) {
    return _firestore
        .collection(_ordersCollection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ── Get Single Order ────────────────────────────────────
  Future<DocumentSnapshot> getOrder(String orderId) async {
    return await _firestore.collection(_ordersCollection).doc(orderId).get();
  }

  // ── Cancel Order (only if status is pending) ────────────
  Future<bool> cancelOrder(String orderId) async {
    try {
      final doc = await _firestore.collection(_ordersCollection).doc(orderId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'] as String? ?? 'pending';

      if (status != 'pending') {
        return false;
      }

      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelledBy': 'customer',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Update Order Status (Admin) ─────────────────────────
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection(_ordersCollection).doc(orderId).update({
      'status': status,
    });
  }
}
