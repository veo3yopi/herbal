import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      if (userJson != null && userJson.isNotEmpty) {
        _user = jsonDecode(userJson) as Map<String, dynamic>;
      }
      notifyListeners();
    }
  }

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
      await _persistSession();
      notifyListeners();
      return null;
    } catch (e) {
      return _mapError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> logout() async {
    try {
      if (_token != null) {
        await _service.logout(token: _token!);
      }
      await _clearSession();
      return null;
    } catch (e) {
      return _mapError(e);
    }
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

  Future<void> _persistSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString(_tokenKey, _token!);
    }
    if (_user != null) {
      await prefs.setString(_userKey, jsonEncode(_user));
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    _token = null;
    _user = null;
    notifyListeners();
  }
}
