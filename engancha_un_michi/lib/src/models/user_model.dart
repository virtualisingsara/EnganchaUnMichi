// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.email = "",
    this.accountType = "adopter",
    this.phone = "",
    this.favs,
  });

  String id;
  String email;
  String accountType;
  String phone;
  List<String> favs;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    accountType: json["accountType"],
    phone: json["phone"],
    favs: json["favs"] == null ? null : List<String>.from(json["favs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    //"id": id,
    "email": email,
    "accountType": accountType,
    "phone": phone,
    "favs": favs == null ? null : List<dynamic>.from(favs.map((x) => x)),
  };
}