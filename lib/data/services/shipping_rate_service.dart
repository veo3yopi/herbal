import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
            ),
          );

  final Dio _dio;

  Future<ShippingRateResponse> fetchRates({
    required String token,
    required int addressId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final payload = {
        'address_id': addressId,
        'items': items,
        'package_type_id': 1,
        'shipment_type': 'PICKUP',
        'is_cod': false,
        'is_use_insurance': false,
        'include_flat_rate': true,
      };
      if (kDebugMode) {
        debugPrint('[ShippingRate] baseUrl=${_dio.options.baseUrl}');
        debugPrint('[ShippingRate] endpoint=/api/v1/ordereverpro/rates');
        debugPrint('[ShippingRate] payload=$payload');
        debugPrint(
          '[ShippingRate] tokenPrefix=${token.length >= 10 ? token.substring(0, 10) : token}...',
        );
      }
      final response = await _dio.post(
        '/api/v1/ordereverpro/rates',
        data: payload,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': token.startsWith('Bearer ')
                ? token
                : 'Bearer $token',
          },
        ),
      );
      final rateList = response.data['rates'] as List<dynamic>;
      final warehouseJson = response.data['warehouse'] as Map<String, dynamic>?;
      final warehouse = warehouseJson == null
          ? null
          : WarehouseModel.fromJson(warehouseJson);
      final rates = rateList
          .map((json) => ShippingRateModel.fromJson(json))
          .toList();
      if (kDebugMode) {
        debugPrint(
          '[ShippingRate] warehouse=${warehouse?.name} rates=${rates.length}',
        );
      }
      return ShippingRateResponse(warehouse: warehouse, rates: rates);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[ShippingRate] error=${e.response?.statusCode} data=${e.response?.data}',
        );
      }
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat ongkir');
    }
  }
}
