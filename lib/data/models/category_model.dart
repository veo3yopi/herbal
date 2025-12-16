import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final int id;
  final String name;
  final String description;
  final List<dynamic> image;
  @JsonKey(name: 'created_at')
  final String createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
