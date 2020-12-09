import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:enganchaunmichi/src/models/cat_model.dart';

class CatsProvider {
  final String _url = 'https://engancha-un-michi.firebaseio.com';

  Future<bool> createCat(CatModel cat) async {
    final url = '$_url/cats.json';
    final response = await http.post(url, body: catModelToJson(cat));
    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<CatModel>> readCats() async {
    final url = '$_url/cats.json';
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

  Future<CatModel> searchCatById(String id) async {
    final url = '$_url/cats/$id.json';
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null) return new CatModel();

    CatModel cat = CatModel.fromJson(decodedData);

    print("SEARCH CAT - " + cat.toString());

    return cat;
}

  Future<List<CatModel>> searchCatsByIds(Future<List<String>> idList) async{
    final List<String> ids = await idList;
    final List<CatModel> cats = new List();
    for (var i = 0; i < ids.length; i++) {
      cats.add(await searchCatById(ids[i]));
    }

    print("SEARCH CATS - " + cats.toString());

    return cats;
  }

  Future<List<CatModel>> searchCats(List<String> idList) async{
    final List<String> ids = await idList;
    final List<CatModel> cats = new List();
    for (var i = 0; i < ids.length; i++) {
      cats.add(await searchCatById(ids[i]));
    }

    print("SEARCH CATS - " + cats.toString());

    return cats;
  }

  Future<bool> updateCat(CatModel cat) async {
    final url = '$_url/cats/${cat.id}.json';
    final response = await http.put(url, body: catModelToJson(cat));
    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<int> deleteCat(String id) async {
    final url = '$_url/cats/$id.json';
    final response = await http.delete(url);
    final decodedData = json.decode(response.body);

    print(decodedData);

    return 1;
  }

  Future<String> uploadImage(File pic) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/druyv7eiu/image/upload?upload_preset=z366eepr');
    final mimeType = mime(pic.path).split('/');
    final request = http.MultipartRequest(
        'POST',
        url
    );
    final file = await http.MultipartFile.fromPath(
        'file',
        pic.path,
        contentType: MediaType(mimeType[0], mimeType[1])
    );
    request.files.add(file);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Error");
      print(response.body);
      return null;
    }

    final data = json.decode(response.body);
    return data['secure_url'];

  }

}