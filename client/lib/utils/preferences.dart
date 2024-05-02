import "package:shared_preferences/shared_preferences.dart";

class Token {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setUserToken(int id) async =>
      await _prefs.setInt("user_id", id);

  static int? getUserToken() => _prefs.getInt('user_id');

  static Future setEmailToken(String email) async =>
      await _prefs.setString('email', email);

  static String? getEmailToken() => _prefs.getString('email');

  static Future setPasswordToken(String password) async =>
      await _prefs.setString('password', password);

  static String? getPasswordToken() => _prefs.getString('password');

  static Future setFirstNameToken(String firstName) async =>
      await _prefs.setString('firstName', firstName);

  static String? getFirstNameToken() => _prefs.getString('firstName');

  static Future setLastNameToken(String lastName) async =>
      await _prefs.setString('lastName', lastName);

  static String? getLastNameToken() => _prefs.getString('lastName');

  static Future setPhonenumberToken(String phonenumber) async =>
      await _prefs.setString('phonenumber', phonenumber);

  static String? getPhonenumberToken() => _prefs.getString('phonenumber');

  static Future setIsSellerToken(bool isSeller) async =>
      await _prefs.setBool('isSeller', isSeller);

  static bool? getIsSellerToken() => _prefs.getBool('isSeller');

  static Future setStreetToken(String street) async =>
      await _prefs.setString('street', street);

  static String? getStreetToken() => _prefs.getString('street');

  static Future setBarangayToken(String barangay) async =>
      await _prefs.setString('barangay', barangay);

  static String? getBarangayToken() => _prefs.getString('barangay');

  static Future setCityToken(String city) async =>
      await _prefs.setString('city', city);

  static String? getCityToken() => _prefs.getString('city');

  static Future setProvinceToken(String province) async =>
      await _prefs.setString('province', province);

  static String? getProvinceToken() => _prefs.getString('province');

  static Future setPostalCodeToken(String postalCode) async =>
      await _prefs.setString('postalCode', postalCode);

  static String? getPostalCodeToken() => _prefs.getString('postalCode');

  static Future removeToken() async => await _prefs.remove('user_id');
}

class SearchHistory {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future addSearchHistory(String item) async {
    List<String> list = _prefs.getStringList('history') == null
        ? []
        : _prefs.getStringList('history')!;
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
