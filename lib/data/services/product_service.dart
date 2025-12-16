import 'package:dio/dio.dart';
import '../../core/app_config.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio;
  ProductService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<List<ProductModel>> fetchProducts({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/api/v1/products',
        queryParameters: {'page': page},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat produk');
    }
  }
}
