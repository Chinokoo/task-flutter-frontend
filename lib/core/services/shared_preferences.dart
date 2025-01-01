import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  //setting a token in shared preferences
  Future<void> setToken(String token) async {
    final preference = await SharedPreferences.getInstance();
    preference.setString("x-auth-token", token);
  }

  //getting a token from shared preferences
  Future<String?> getToken() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString("x-auth-token");
  }

  Future<void> clearToken(String token) async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove("x-auth-token");
  }
}
