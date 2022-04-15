import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/login_response_response.dart';

class SharedService {
  static const String KEY_NAME = "login_key";
  static Future<bool> isLoggedIn() async {
    var isCacheKeyExist = await APICacheManager().isAPICacheKeyExist(KEY_NAME);
    return isCacheKeyExist;
  }

  static Future<void> setLoginDetails(LoginResponseModel model) async {
    APICacheDBModel cacheDBModel =
        APICacheDBModel(key: KEY_NAME, syncData: jsonEncode(model.toJson()));
    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<LoginResponseModel?> loginDetails() async {
    var isCacheKeyExist = await APICacheManager().isAPICacheKeyExist(KEY_NAME);

    if (isCacheKeyExist) {
      var cacheData = await APICacheManager().getCacheData(KEY_NAME);
      print(cacheData.syncData.toString());
      return loginResponseJson(cacheData.syncData);
    }
    return null;
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache(KEY_NAME);
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
