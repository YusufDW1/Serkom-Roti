// lib/services/database_helper.dart
//
// SQLite-based local cart persistence using sqflite.
// Supports accumulating different items (upsert by productId).

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'roti_saku_cart.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        imageUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // ── Insert or increment (upsert) ──────────────────────
  Future<int> insertItem({
    required String productId,
    required String name,
    required double price,
    required String? imageUrl,
  }) async {
    final db = await database;

    // Check if item already exists
    final existing = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      // Increment quantity
      return await db.update(
        'cart_items',
        {'quantity': (existing.first['quantity'] as int) + 1},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }

    // Insert new item
    return await db.insert(
      'cart_items',
      {
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': 1,
        'imageUrl': imageUrl ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // ── Get all items ──────────────────────────────────────
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query('cart_items', orderBy: 'createdAt ASC');
  }

  // ── Update quantity ────────────────────────────────────
  Future<int> updateQuantity(String productId, int newQty) async {
    final db = await database;
    if (newQty <= 0) {
      return await deleteItem(productId);
    }
    return await db.update(
      'cart_items',
      {'quantity': newQty},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // ── Remove item ────────────────────────────────────────
  Future<int> deleteItem(String productId) async {
    final db = await database;
    return await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // ── Clear cart ─────────────────────────────────────────
  Future<int> clearCart() async {
    final db = await database;
    return await db.delete('cart_items');
  }

  // ── Get total ──────────────────────────────────────────
  Future<double> getTotal() async {
    final db = await database;
    // Using a safe approach to handle null returned from rawQuery on older sqflite
    final results = await db.rawQuery(
      'SELECT COALESCE(SUM(price * quantity), 0) as total FROM cart_items',
    );
    if (results.isEmpty) {
      return 0.0;
    }
    return (results.first['total'] ?? 0) as double;
  }

  // ── Get item count ────────────────────────────────────────
  Future<int> getItemCount() async {
    final db = await database;
    final results = await db.rawQuery('SELECT COUNT(*) FROM cart_items');
    return results.first['COUNT(*)'] as int;
  }
}
