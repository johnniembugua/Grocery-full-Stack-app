import 'package:flutter_sqflite/models/model.dart';

class ProductModel extends Model {
  static String table = "products";

  @override
  int? id;
  int categoryId;
  String productName;
  String? productDesc;
  double? price;
  String? productPic;

  ProductModel({
    this.id,
    required this.productName,
    required this.categoryId,
    this.price,
    this.productDesc,
    this.productPic,
  });

  static ProductModel fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      price: json["price"],
      productDesc: json["productDesc"].toString(),
      productPic: json["productPic"],
      productName: json["productName"].toString(),
      categoryId: json["categoryId"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "productName": productName,
      "productDesc": productDesc,
      "price": price,
      "productPic": productPic,
      "categoryId": categoryId,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
