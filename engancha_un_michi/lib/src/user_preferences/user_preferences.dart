import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }


  // GET y SET de la última página
  get lastPage {
    return _prefs.getString('lastPage') ?? 'login';
  }

  set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }

  // GET y SET de la lista de favoritos
  get favs {
    return _prefs.getStringList("favs") ?? []; // Si no existe, retorna []
  }

  set favs(List<String> value){
    _prefs.setStringList("favs", value);
  }

}

