import 'package:flutter/material.dart';

import '../../../data/models/district_model.dart';
import '../../../data/services/district_service.dart';

class DistrictProvider extends ChangeNotifier {
  DistrictProvider({DistrictService? service})
      : _service = service ?? DistrictService();

  final DistrictService _service;

  List<DistrictModel> districts = [];
  bool isLoading = false;
  String? error;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchDistricts({required int cityId}) async {
    if (_token == null || _token!.isEmpty) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      districts = await _service.fetchDistricts(
        token: _token!,
        cityId: cityId,
      );
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    districts = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
