import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
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
      print(e.toString());
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
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
