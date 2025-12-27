class AddressModel {
  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.postalCode,
    required this.provinceName,
    required this.cityName,
    required this.districtName,
    required this.subDistrictId,
    required this.subDistrictName,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final int userId;
  final String label;
  final String recipientName;
  final String phoneNumber;
  final String addressLine;
  final int provinceId;
  final int cityId;
  final int districtId;
  final String postalCode;
  final String provinceName;
  final String cityName;
  final String districtName;
  final String subDistrictId;
  final String subDistrictName;
  final bool isDefault;
  final String latitude;
  final String longitude;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      label: json['label'] as String,
      recipientName: json['recipient_name'] as String,
      phoneNumber: json['phone_number'] as String,
      addressLine: json['address_line'] as String,
      provinceId: (json['province_id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      districtId: (json['district_id'] as num).toInt(),
      postalCode: json['postal_code'] as String,
      provinceName: json['province_name'] as String,
      cityName: json['city_name'] as String,
      districtName: json['district_name'] as String,
      subDistrictId: json['sub_district_id'].toString(),
      subDistrictName: json['sub_district_name'] as String,
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'address_line': addressLine,
      'province_id': provinceId,
      'city_id': cityId,
      'district_id': districtId,
      'postal_code': postalCode,
      'province_name': provinceName,
      'city_name': cityName,
      'district_name': districtName,
      'sub_district_id': subDistrictId,
      'sub_district_name': subDistrictName,
      'is_default': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
