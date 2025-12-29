import 'package:flutter/material.dart';

import '../../../data/models/city_model.dart';
import '../../../data/services/city_service.dart';

class CityProvider extends ChangeNotifier {
  CityProvider({CityService? service}) : _service = service ?? CityService();

  final CityService _service;

  List<CityModel> cities = [];
  bool isLoading = false;
  String? error;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchCities({required int provinceId}) async {
    if (_token == null || _token!.isEmpty) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      cities = await _service.fetchCities(
        token: _token!,
        provinceId: provinceId,
      );
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    cities = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
