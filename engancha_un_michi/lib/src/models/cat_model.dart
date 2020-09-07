// To parse this JSON data, do
//
//     final catModel = catModelFromJson(jsonString);

import 'dart:convert';

CatModel catModelFromJson(String str) => CatModel.fromJson(json.decode(str));

String catModelToJson(CatModel data) => json.encode(data.toJson());

class CatModel {
  CatModel({
    this.id,
    this.name = "",
    this.gender = "Macho",
    this.age = 0,
    this.desc = "",
    this.pictureUrl,
  });

  String id;
  String name;
  String gender;
  int age;
  String desc;
  String pictureUrl;

  factory CatModel.fromJson(Map<String, dynamic> json) => CatModel(
    id: json["id"],
    name: json["name"],
    gender: json["gender"],
    age: json["age"],
    desc: json["desc"],
    pictureUrl: json["pictureURL"],
  );

  Map<String, dynamic> toJson() => {
    //"id": id,
    "name": name,
    "gender": gender,
    "age": age,
    "desc": desc,
    "pictureURL": pictureUrl,
  };
}
