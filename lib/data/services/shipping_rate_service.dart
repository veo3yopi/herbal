import 'package:dio/dio.dart';

import '../../core/app_config.dart';
import '../models/shipping_rate_model.dart';
import '../models/warehouse_model.dart';

class ShippingRateResponse {
  ShippingRateResponse({required this.warehouse, required this.rates});

  final WarehouseModel? warehouse;
  final List<ShippingRateModel> rates;
}

class ShippingRateService {
  ShippingRateService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  Future<ShippingRateResponse> fetchRates({
    required String token,
    required int addressId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/ordereverpro/rates',
        data: {
          'address_id': addressId,
          'items': items,
          'package_type_id': 1,
          'shipment_type': 'PICKUP',
          'is_cod': false,
          'is_use_insurance': false,
          'include_flat_rate': true,
          'logistic_codes': ['JNE', 'SICEPAT'],
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
          },
        ),
      );
      final rateList = response.data['rates'] as List<dynamic>;
      final warehouseJson = response.data['warehouse'] as Map<String, dynamic>?;
      final warehouse =
          warehouseJson == null ? null : WarehouseModel.fromJson(warehouseJson);
      final rates =
          rateList.map((json) => ShippingRateModel.fromJson(json)).toList();
      return ShippingRateResponse(warehouse: warehouse, rates: rates);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat ongkir');
    }
  }
}
