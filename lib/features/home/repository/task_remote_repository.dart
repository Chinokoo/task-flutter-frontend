import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  Future<void> createTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueDate,
    required String token,
  }) async {
    try {
      http.Response res = await http.post(
          Uri.parse("${Constants.backendUrl}/api/tasks/create"),
          headers: {
            "Content-type": "application/json",
            "x-auth-token": token,
          },
          body: {
            "title": title,
            "description": description,
            "hexColor": hexColor,
            "dueDate": dueDate.toIso8601String(),
          });

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
