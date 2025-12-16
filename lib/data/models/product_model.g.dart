// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  price: json['price'] as num,
  weight: json['weight'] as num,
  stock: json['stock'] as num,
  isFeatured: json['is_featured'] as bool,
  featuredPriority: (json['featured_priority'] as num).toInt(),
  isActive: json['is_active'] as bool,
  primaryImage: json['primary_image'] as String?,
  primaryImageThumb: json['primary_image_thumb'] as String?,
  image: json['image'] as List<dynamic>,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'weight': instance.weight,
      'stock': instance.stock,
      'is_featured': instance.isFeatured,
      'featured_priority': instance.featuredPriority,
      'is_active': instance.isActive,
      'primary_image': instance.primaryImage,
      'primary_image_thumb': instance.primaryImageThumb,
      'image': instance.image,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };
