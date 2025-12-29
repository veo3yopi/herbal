import 'package:flutter/material.dart';

import '../../../data/models/sub_district_model.dart';
import '../../../data/services/sub_district_service.dart';

class SubDistrictProvider extends ChangeNotifier {
  SubDistrictProvider({SubDistrictService? service})
      : _service = service ?? SubDistrictService();

  final SubDistrictService _service;

  List<SubDistrictModel> subDistricts = [];
  bool isLoading = false;
  String? error;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchSubDistricts({required int districtId}) async {
    if (_token == null || _token!.isEmpty) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      subDistricts = await _service.fetchSubDistricts(
        token: _token!,
        districtId: districtId,
      );
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    subDistricts = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
