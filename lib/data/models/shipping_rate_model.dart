class ShippingRateModel {
  ShippingRateModel({
    required this.signedKey,
    required this.name,
    required this.logisticName,
    required this.logisticLogoUrl,
    required this.rateCode,
    required this.rateName,
    required this.minDuration,
    required this.maxDuration,
    required this.durationType,
    required this.price,
    required this.insurancePrice,
    required this.weight,
    required this.volumeWeight,
    required this.isAvailablePickupToday,
    required this.cashback,
    required this.isFlatRate,
  });

  final String signedKey;
  final String name;
  final String logisticName;
  final String logisticLogoUrl;
  final String rateCode;
  final String rateName;
  final int minDuration;
  final int maxDuration;
  final String durationType;
  final int price;
  final int insurancePrice;
  final num weight;
  final num volumeWeight;
  final bool isAvailablePickupToday;
  final int cashback;
  final bool isFlatRate;

  factory ShippingRateModel.fromJson(Map<String, dynamic> json) {
    return ShippingRateModel(
      signedKey: json['signed_key'] as String,
      name: json['name'] as String,
      logisticName: json['logistic_name'] as String,
      logisticLogoUrl: json['logistic_logo_url'] as String? ?? '',
      rateCode: json['rate_code'] as String,
      rateName: json['rate_name'] as String,
      minDuration: (json['min_duration'] as num).toInt(),
      maxDuration: (json['max_duration'] as num).toInt(),
      durationType: json['duration_type'] as String,
      price: (json['price'] as num).toInt(),
      insurancePrice: (json['insurance_price'] as num).toInt(),
      weight: json['weight'] as num,
      volumeWeight: json['volume_weight'] as num,
      isAvailablePickupToday: json['is_available_pickup_today'] == true,
      cashback: (json['cashback'] as num).toInt(),
      isFlatRate: json['is_flat_rate'] == true,
    );
  }
}
