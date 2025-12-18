import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<String?> requestOtp({required String name, required String phone}) async {
    try {
      _setLoading(true);
      await _service.requestOtp(name: name, phone: phone);
      return null;
    } catch (e) {
      return _mapError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> verifyOtp({
    required String name,
    required String phone,
    required String otp,
  }) async {
    try {
      _setLoading(true);
      final data = await _service.verifyOtp(name: name, phone: phone, otp: otp);
      _token = data['token'] as String?;
      _user = data['user'] as Map<String, dynamic>?;
      notifyListeners();
      return null;
    } catch (e) {
      return _mapError(e);
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Terjadi kesalahan. Coba lagi.';
  }
}
