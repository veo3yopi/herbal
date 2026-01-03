import 'dart:convert';

import 'package:coffe/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  static const _cartKey = 'cart_items';
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get totalPrice {
    int total = 0;
    for (final item in _items) {
      final product = item['product'] as ProductModel;
      final qty = item['qty'] as int;
      total += product.price.toInt() * qty;
    }
    return total;
  }

  void addToCart(ProductModel product) {
    final index = _items.indexWhere(
      (item) => (item['product'] as ProductModel).id == product.id,
    );
    if (index != -1) {
      _items[index]['qty'] = (_items[index]['qty'] as int) + 1;
    } else {
      _items.add({'product': product, 'qty': 1});
    }
    _persistCart();
    notifyListeners();
  }

  void removeItem(int index) {
    final currentQty = _items[index]['qty'] as int;
    if (currentQty > 1) {
      _items[index]['qty'] = currentQty - 1;
    } else {
      _items.removeAt(index);
    }
    _persistCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _persistCart();
    notifyListeners();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _items
        ..clear()
        ..addAll(
          decoded.map((entry) {
            final map = entry as Map<String, dynamic>;
            final productJson = map['product'] as Map<String, dynamic>;
            return {
              'product': ProductModel.fromJson(productJson),
              'qty': (map['qty'] as num).toInt(),
            };
          }),
        );
      notifyListeners();
    } catch (_) {
      // Jika data rusak, kosongkan agar aman
      _items.clear();
      await prefs.remove(_cartKey);
      notifyListeners();
    }
  }

  Future<void> _persistCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((item) {
      final product = item['product'] as ProductModel;
      final qty = item['qty'] as int;
      return {
        'product': product.toJson(),
        'qty': qty,
      };
    }).toList();
    await prefs.setString(_cartKey, jsonEncode(data));
  }
}
