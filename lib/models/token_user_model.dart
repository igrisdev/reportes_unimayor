// To parse this JSON data, do
//
//     final tokenUserModel = tokenUserModelFromJson(jsonString);

import 'dart:convert';

TokenUserModel tokenUserModelFromJson(String str) =>
    TokenUserModel.fromJson(json.decode(str));

String tokenUserModelToJson(TokenUserModel data) => json.encode(data.toJson());

class TokenUserModel {
  String token;

  TokenUserModel({required this.token});

  TokenUserModel copyWith({String? token}) =>
      TokenUserModel(token: token ?? this.token);

  factory TokenUserModel.fromJson(Map<String, dynamic> json) =>
      TokenUserModel(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": token};
}
