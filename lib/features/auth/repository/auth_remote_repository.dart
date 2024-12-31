import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  final sharedPreferencesService = SharedPreferencesService();
  //sign up function
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res =
          await http.post(Uri.parse('${Constants.backendUrl}/api/auth/signup'),
              headers: {'Content-Type': 'application/json'},
              //converts a map to a JSON object
              body: jsonEncode({
                "name": name,
                "email": email,
                "password": password,
              }));

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)["message"];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  //sign in function
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res =
          await http.post(Uri.parse('${Constants.backendUrl}/api/auth/signin'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({"email": email, "password": password}));
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)["message"];
      }

      final token = jsonDecode(res.body)["token"];
      await sharedPreferencesService.setToken(token);
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> getUserData() async {
    try {
      final token = await sharedPreferencesService.getToken();

      if (token == null) {
        throw "User not authenticated";
      }
      final res = await http.get(
          Uri.parse('${Constants.backendUrl}/api/auth/check-auth'),
          headers: {
            "Content-type": "application/json",
            "x-auth-token": token,
          });
      if (res.statusCode != 200) {
        AuthLocalRepository().getUser();
        // throw jsonDecode(res.body)["message"];
      }
      final jsonData = jsonDecode(res.body);
      final user = jsonData["user"];

      return UserModel.fromJson(jsonEncode(user));
    } catch (e) {
      throw e.toString();
    }
  }
}
