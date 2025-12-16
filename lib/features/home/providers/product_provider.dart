import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service;
  ProductProvider({ProductService? service})
    : _service = service ?? ProductService();

  List<ProductModel> products = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await _service.fetchProducts();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
