import "package:shared_preferences/shared_preferences.dart";

class Token {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setUserToken(int id) async =>
      await _prefs.setInt("user_id", id);

  static int? getUserToken() => _prefs.getInt('user_id');

  static Future removeToken() async => await _prefs.remove('user_id');
}

class SearchHistory {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future addSearchHistory(String item) async {
    List<String> list = _prefs.getStringList('history') == null ? [] : _prefs.getStringList('history')! ;
    if (list.length == 5) {
      list.removeLast();
    }
    list.insert(0, item);
    await _prefs.remove('history');
    await _prefs.setStringList('history', list);
  }

  static List<String> getSearchHistory() {
    return _prefs.getStringList('history')!;
  }
}