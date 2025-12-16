import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final int id;
  final String name;
  final String description;
  final num price;
  final num weight;
  final num stock;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @JsonKey(name: 'featured_priority')
  final int featuredPriority;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'primary_image')
  final String? primaryImage;
  @JsonKey(name: 'primary_image_thumb')
  final String? primaryImageThumb;
  final List<dynamic> image;
  final List<CategoryModel> categories;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.stock,
    required this.isFeatured,
    required this.featuredPriority,
    required this.isActive,
    required this.primaryImage,
    required this.primaryImageThumb,
    required this.image,
    required this.categories,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
