import 'package:dio/dio.dart';

import '../../core/app_config.dart';
import '../models/category_model.dart';

class CategoryService {
  final Dio _dio;
  CategoryService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('/api/v1/categories');
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi Kesalahan');
    }
  }
}
