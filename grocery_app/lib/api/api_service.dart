import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/config.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/models/product_filter.dart';
import 'package:http/http.dart' as http;

final apiService = Provider((ref) => APIService());

class APIService {
  static var client = http.Client();

  Future<List<Category>?> getCategories(page, pageSize) async {
    Map<String, String> requestHeaders = {'Content-Type': 'appliacation/json'};

    Map<String, String> queryString = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    var url = Uri.http(Config.apiURL, Config.categoryAPI, queryString);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return categoriesFromJson(data["data"]);
    } else {
      return null;
    }
  }

  Future<List<Product>?> getFilterModel(
      ProductFilterModel productFilterModel) async {
    Map<String, String> requestHeaders = {'Content-Type': 'appliacation/json'};

    Map<String, String> queryString = {
      'page': productFilterModel.paginationModel.page.toString(),
      'pageSize': productFilterModel.paginationModel.pageSize.toString(),
    };
    if (productFilterModel.categoryId != null) {
      queryString["categoryId"] = productFilterModel.categoryId!;
    }
    var url = Uri.http(Config.apiURL, Config.productAPI, queryString);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return productsFromJson(data["data"]);
    } else {
      return null;
    }
  }
}
