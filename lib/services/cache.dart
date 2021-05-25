import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  const Cache(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  Future<bool?> saveAppName(String value) async {
    return await _sharedPreferences.setString('name', value);
  }

  String? loadAppName() {
    return _sharedPreferences.getString('name');
  }

  Future<void> clearCache() async {
    await _sharedPreferences.remove('name');
  }
}
