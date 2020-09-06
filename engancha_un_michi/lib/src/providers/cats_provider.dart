import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:enganchaunmichi/src/models/cat_model.dart';

class CatsProvider {
  final String _url = "https://engancha-un-michi.firebaseio.com";

  Future<bool> createCat(CatModel cat) async {
    final url = "$_url/cats.json";
    final response = await http.post(url, body: catModelToJson(cat));
    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<CatModel>> readCats() async {
    final url = "$_url/cats.json";
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<CatModel> cats = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, cat) {
      final catTemp = CatModel.fromJson(cat);
      catTemp.id = id;
      cats.add(catTemp);
    });

    return cats;
  }

}