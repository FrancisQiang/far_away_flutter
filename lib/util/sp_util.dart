import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {

  factory SharedPreferenceUtil() => _getInstance();

  static SharedPreferenceUtil get instance => _getInstance();
  static SharedPreferenceUtil _instance;

  SharedPreferenceUtil._internal();

  static SharedPreferenceUtil _getInstance() {
    if (_instance == null) {
      _instance = SharedPreferenceUtil._internal();
    }
    return _instance;
  }

  Future setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future setBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future setStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }

  Future<bool> readAndSaveList(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> strings = prefs.getStringList(key) ?? [];
    if (strings.length >= 10) return false;
    strings.add(data);
    await prefs.setStringList(key, strings);
    return true;
  }

  void changeListItem(String key, String data, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> strings = prefs.getStringList(key) ?? [];
    strings[index] = data;
    await prefs.setStringList(key, strings);
  }

  void removeListItem(String key, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> strings = prefs.getStringList(key) ?? [];
    strings.removeAt(index);
    await prefs.setStringList(key, strings);
  }


  //-----------------------------------------------------get----------------------------------------------------


  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<bool> getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<List<String>> readList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> strings = prefs.getStringList(key) ?? [];
    return strings;
  }
}
