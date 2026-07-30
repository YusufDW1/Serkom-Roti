// lib/features/order/models/order_model.dart
//
// Model for an order submitted to Firebase Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

class OrderModel {
  final String? orderId;
  final String customerName;
  final String? customerId;
  final List<OrderItem> items;
  final double total;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;
  final DateTime? cancelledAt;

  OrderModel({
    this.orderId,
    required this.customerName,
    this.customerId,
    required this.items,
    required this.total,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
    this.createdAt,
    this.cancelledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerId': customerId ?? '',
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      customerName: data['customerName'] as String,
      customerId: data['customerId'] as String?,
      items: (data['items'] as List<dynamic>)
          .map((e) => OrderItem(
                productId: e['productId'] as String,
                name: e['name'] as String,
                price: e['price'] as double,
                quantity: e['quantity'] as int,
              ))
          .toList(),
      total: data['total'] as double,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
    );
  }
}
