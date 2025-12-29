import 'package:dio/dio.dart';
import 'dart:convert';

import '../../core/app_config.dart';
import '../models/province_model.dart';

class ProvinceService {
  final Dio _dio;
  ProvinceService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<List<ProvinceModel>> fetchProvinces({required String token}) async {
    try {
      final authHeader =
          token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await _dio.get(
        '/api/v1/shipping/provinces',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': authHeader,
          },
        ),
      );
      final raw = response.data;
      final data = _normalizeList(raw);
      return data.map((json) => ProvinceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  List<dynamic> _normalizeList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is String) {
      final decoded = jsonDecode(raw);
      return _normalizeList(decoded);
    }
    if (raw is Map && raw['data'] is List) {
      return raw['data'] as List<dynamic>;
    }
    throw Exception('Format data provinsi tidak dikenal');
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'Gagal memuat data provinsi';
  }
}
