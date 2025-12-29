class DistrictModel {
  DistrictModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.everproDistrictId,
  });

  final int id;
  final int cityId;
  final String name;
  final String everproDistrictId;

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: (json['id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      name: json['name'] as String,
      everproDistrictId: json['everpro_district_id'] as String,
    );
  }
}
