import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();

  Future<void> createTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueDate,
  }) async {
    try {
      final token = await sharedPreferencesService.getToken();

      http.Response res =
          await http.post(Uri.parse("${Constants.backendUrl}/api/tasks/create"),
              headers: {
                "Content-type": "application/json",
                "x-auth-token": token!,
              },
              body: jsonEncode({
                "title": title,
                "description": description,
                "hexColor": hexColor,
                "dueDate": dueDate.toIso8601String(),
              }));

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final token = await sharedPreferencesService.getToken();
      http.Response res = await http
          .get(Uri.parse("${Constants.backendUrl}/api/tasks/"), headers: {
        "Content-type": "application/json",
        "x-auth-token": token!,
      });

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)["message"];
      }

      List<dynamic> tasksJson = jsonDecode(res.body)["tasks"];

      List<Task> tasks = [];

      for (var task in tasksJson) {
        //tasks.add(Task.fromJson(tasksJson[task]));
        tasks.add(Task.fromJson(task));
      }

      return tasks;
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
