// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$$_ProductFromJson(Map<String, dynamic> json) => _$_Product(
      productName: json['productName'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      productShortDescription: json['productShortDescription'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productSalePrice: (json['productSalePrice'] as num).toDouble(),
      productImage: json['productImage'] as String,
      productDescription: json['productDescription'] as String,
      productSKU: json['productSKU'] as String,
      productType: json['productType'] as String,
      stockStatus: json['stockStatus'] as String,
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'category': instance.category,
      'productShortDescription': instance.productShortDescription,
      'productPrice': instance.productPrice,
      'productSalePrice': instance.productSalePrice,
      'productImage': instance.productImage,
      'productDescription': instance.productDescription,
      'productSKU': instance.productSKU,
      'productType': instance.productType,
      'stockStatus': instance.stockStatus,
      'productId': instance.productId,
    };
