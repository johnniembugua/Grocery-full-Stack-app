import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  late final String message;
  late final Data data;
  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    data = Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data["message"] = message;
    _data["data"] = data.toJson();

    return _data;
  }
}

class Data {
  late final String fullName;
  late final String email;
  late final String userId;
  late final String token;
  Data({
    required this.fullName,
    required this.email,
    required this.userId,
    required this.token,
  });
  Data.fromJson(Map<String, dynamic> json) {
    fullName = json["fullName"];
    email = json["email"];
    userId = json["userId"];
    token = json["token"];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data["fullName"] = fullName;
    _data["email"] = email;
    _data["userId"] = userId;
    _data["token"] = token;

    return _data;
  }
}
