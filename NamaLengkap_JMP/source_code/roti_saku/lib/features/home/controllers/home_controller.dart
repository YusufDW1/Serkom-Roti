/// lib/features/home/controllers/home_controller.dart
///
/// GetX controller for the Customer Home screen.
/// Manages bakery item list, navigation to detail,
/// and cart interactions.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bakery_item.dart';
import '../../../services/database_helper.dart';

class HomeController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Mock bakery items data
  final RxList<BakeryItem> bakeryItems = <BakeryItem>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  void _loadItems() {
    bakeryItems.value = [
      BakeryItem(
        id: '1',
        name: 'Roti Saku Original',
        description:
            'Roti tawar lembut dengan aroma butter dan tekstur yang fluffy. Cocok untuk sarapan.',
        price: 12000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Roti+Saku',
        category: 'Bread',
      ),
      BakeryItem(
        id: '2',
        name: 'Croissant Butter',
        description:
            'Croissant berlapis dengan mentega asli, renyah di luar dan lembut di dalam.',
        price: 18000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Croissant',
        category: 'Pastry',
      ),
      BakeryItem(
        id: '3',
        name: 'Chocolate Muffin',
        description:
            'Muffin cokelat pekat dengan chips cokelat di dalamnya. Pahit dan manis seimbang.',
        price: 15000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Muffin',
        category: 'Cake',
      ),
      BakeryItem(
        id: '4',
        name: 'Donut Gula',
        description:
            'Donut empuk dengan topping Gula Halus. Classic dan disukai semua usia.',
        price: 10000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Donut',
        category: 'Snack',
      ),
      BakeryItem(
        id: '5',
        name: 'Roti Tawar Gandum',
        description:
            'Roti tawar gandum sehat dengan serat tinggi. Baik untuk diet dan kesehatan.',
        price: 22000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Gandum',
        category: 'Bread',
      ),
      BakeryItem(
        id: '6',
        name: 'Pain Au Chocolat',
        description:
            'Pastry Prancis isi cokelat. Lembut, berlapis, dan lumer di mulut.',
        price: 20000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Pain+Au+Chocolat',
        category: 'Pastry',
      ),
      BakeryItem(
        id: '7',
        name: 'Kue Brownies',
        description:
            'Brownies fudgy dengan topping walnut. Moist dan kaya rasa cokelat.',
        price: 25000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Brownies',
        category: 'Cake',
      ),
      BakeryItem(
        id: '8',
        name: 'Baguette Paris',
        description:
            'Roti Prancis klasik dengan kulit yang renyah dan interior berongga. Autentik.',
        price: 28000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Baguette',
        category: 'Bread',
      ),
      BakeryItem(
        id: '9',
        name: 'Cookie Choco Chip',
        description:
            'Cookie butter dengan chunks cokelat yang melimpah. Renyah di pinggir.',
        price: 8000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Cookie',
        category: 'Snack',
      ),
      BakeryItem(
        id: '10',
        name: 'Cheese Danish',
        description:
            'Pastry isi keju cheddar dengan butiran tos yang gurih. Sewaktu panas paling nikmat.',
        price: 16000,
        imageUrl: 'https://placehold.co/400x400/f5e6d3/5d4037?text=Danish',
        category: 'Pastry',
      ),
    ];

    isLoading.value = false;
  }

  /// Adds an item to the cart and shows a snackbar confirmation.
  Future<void> addToCart(BakeryItem item) async {
    await _dbHelper.insertItem(
      productId: item.id,
      name: item.name,
      price: item.price,
      imageUrl: item.imageUrl,
    );

    // Refresh cart count
    update();

    Get.snackbar(
      'Berhasil',
      '${item.name} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  /// Navigates to the Detail screen for a specific item.
  void navigateToDetail(BakeryItem item) {
    Get.toNamed('/detail', arguments: item);
  }

  /// Navigates to the Cart screen.
  void navigateToCart() {
    Get.toNamed('/cart');
  }
}