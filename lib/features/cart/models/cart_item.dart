/// lib/features/cart/models/cart_item.dart
///
/// Model for an item in the shopping cart.

class CartItemModel {
  final int id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String createdAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.createdAt,
  });

  double get subtotal => price * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int,
      productId: map['productId'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      imageUrl: map['imageUrl'] as String?,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl ?? '',
      'createdAt': createdAt,
    };
  }
}