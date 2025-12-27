import 'package:dio/dio.dart';

import '../../core/app_config.dart';
import '../models/address_model.dart';

class AddressService {
  AddressService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  Future<List<AddressModel>> fetchAddresses({required String token}) async {
    try {
      final response = await _dio.get(
        '/api/v1/addresses',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => AddressModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat alamat');
    }
  }

  Future<AddressModel> createAddress({
    required String token,
    required AddressModel address,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/addresses',
        data: address.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return AddressModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah alamat');
    }
  }
}
