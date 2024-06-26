import 'dart:convert';
import 'package:enganchaunmichi/src/models/user_model.dart';
import 'package:enganchaunmichi/src/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UsersProvider {

  final String _firebaseKey = 'AIzaSyAcy0qDQwGidqtkjEDxV29a78VHWszp56Y';
  final String _url = 'https://engancha-un-michi.firebaseio.com';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return { 'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return { 'ok': false, 'message': decodedResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return { 'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return { 'ok': false, 'message': decodedResponse['error']['message']};
    }
  }

  Future<bool> createUser(UserModel user) async {
    final url = '$_url/users.json';
    final response = await http.post(url, body: userModelToJson(user));
    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<UserModel>> readUsers() async {
    final url = '$_url/users.json';
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<UserModel> users = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, user) {
      final userTemp = UserModel.fromJson(user);
      userTemp.id = id;
      users.add(userTemp);
    });

    return users;
  }

  Future<UserModel> searchUserById(String id) async {
    final url = '$_url/users/$id.json';
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null) return new UserModel();

    UserModel user = UserModel.fromJson(decodedData);

    print("SEARCH USER - " + user.toString());

    return user;
  }

  Future<bool> updateUser(UserModel user) async {
    final url = '$_url/users/${user.id}.json';
    final response = await http.put(url, body: userModelToJson(user));
    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

}