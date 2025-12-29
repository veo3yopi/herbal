class ProvinceModel {
  ProvinceModel({
    required this.id,
    required this.name,
    required this.everproProvinceId,
  });

  final int id;
  final String name;
  final String everproProvinceId;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      everproProvinceId: json['everpro_province_id'] as String,
    );
  }
}
