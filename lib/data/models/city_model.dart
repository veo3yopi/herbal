class CityModel {
  CityModel({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.everproCityId,
  });

  final int id;
  final int provinceId;
  final String name;
  final String everproCityId;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num).toInt(),
      provinceId: (json['province_id'] as num).toInt(),
      name: json['name'] as String,
      everproCityId: json['everpro_city_id'] as String,
    );
  }
}
