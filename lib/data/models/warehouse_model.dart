class WarehouseModel {
  WarehouseModel({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String name;
  final num distanceKm;
  final String address;
  final num latitude;
  final num longitude;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      distanceKm: json['distance_km'] as num,
      address: json['address'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
    );
  }
}
