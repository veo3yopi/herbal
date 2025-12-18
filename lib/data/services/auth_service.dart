import 'package:dio/dio.dart';

import '../../core/app_config.dart';

class AuthService {
  AuthService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  final Dio _dio;

  Future<void> requestOtp({required String name, required String phone}) async {
    await _dio.post(
      '/api/v1/auth/register',
      data: {
        'name': name,
        'phone': phone,
      },
    );
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String name,
    required String phone,
    required String otp,
  }) async {
    final response = await _dio.post(
      '/api/v1/auth/verify-otp',
      data: {
        'name': name,
        'phone': phone,
        'otp': otp,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
