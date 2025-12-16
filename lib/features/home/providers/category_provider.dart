import 'package:flutter/material.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service;

  CategoryProvider({CategoryService? service})
    : _service = service ?? CategoryService();

  List<CategoryModel> categories = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCategories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
