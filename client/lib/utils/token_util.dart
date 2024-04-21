import "package:shared_preferences/shared_preferences.dart";

class Token {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setUserToken(int id) async =>
      await _prefs.setInt("user_id", id);

  static int? getUserToken() => _prefs.getInt('user_id');

  static Future removeToken() async => await _prefs.remove('user_id');
}
