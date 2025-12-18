import 'package:coffe/data/models/product_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
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
    notifyListeners();
  }

  void removeItem(int index) {
    final currentQty = _items[index]['qty'] as int;
    if (currentQty > 1) {
      _items[index]['qty'] = currentQty - 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
