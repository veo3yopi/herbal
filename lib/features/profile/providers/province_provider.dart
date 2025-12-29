import 'package:flutter/material.dart';

import '../../../data/models/province_model.dart';
import '../../../data/services/province_service.dart';

class ProvinceProvider extends ChangeNotifier {
  ProvinceProvider({ProvinceService? service})
      : _service = service ?? ProvinceService();

  final ProvinceService _service;

  List<ProvinceModel> provinces = [];
  bool isLoading = false;
  String? error;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchProvinces() async {
    if (_token == null || _token!.isEmpty) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      provinces = await _service.fetchProvinces(token: _token!);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
