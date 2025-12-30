import 'package:flutter/material.dart';

import '../../../data/models/address_model.dart';
import '../../../data/services/address_service.dart';

class AddressProvider extends ChangeNotifier {
  AddressProvider({AddressService? service}) : _service = service ?? AddressService();

  final AddressService _service;
  String? _token;

  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _error;

  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setToken(String? token) {
    _token = token;
  }

  Future<void> fetchAddresses() async {
    if (_token == null || _token!.isEmpty) return;
    _setLoading(true);
    _error = null;
    try {
      _addresses = await _service.fetchAddresses(token: _token!);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> addAddress(AddressModel address) async {
    if (_token == null || _token!.isEmpty) return 'Token tidak tersedia';
    _setLoading(true);
    _error = null;
    try {
      final created = await _service.createAddress(
        token: _token!,
        address: address,
      );
      _addresses = [created, ..._addresses];
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<String?> updateAddress({
    required int addressId,
    required AddressModel address,
  }) async {
    if (_token == null || _token!.isEmpty) return 'Token tidak tersedia';
    _setLoading(true);
    _error = null;
    try {
      final updated = await _service.updateAddress(
        token: _token!,
        addressId: addressId,
        address: address,
      );
      final index = _addresses.indexWhere((item) => item.id == addressId);
      if (index != -1) {
        _addresses[index] = updated;
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
