class SubDistrictModel {
  SubDistrictModel({
    required this.id,
    required this.districtId,
    required this.name,
    required this.postalCode,
  });

  final int id;
  final int districtId;
  final String name;
  final String postalCode;

  factory SubDistrictModel.fromJson(Map<String, dynamic> json) {
    return SubDistrictModel(
      id: (json['id'] as num).toInt(),
      districtId: (json['district_id'] as num).toInt(),
      name: json['name'] as String,
      postalCode: json['postal_code'] as String,
    );
  }
}
