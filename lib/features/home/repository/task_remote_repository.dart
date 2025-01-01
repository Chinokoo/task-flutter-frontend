import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();
  TaskLocalRepository taskLocalRepository = TaskLocalRepository();

  Future<Task> createTask({
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
      return Task.fromJson(jsonDecode(res.body)["task"]);
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

      await taskLocalRepository.insertTasks(tasks);

      return tasks;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks != null) return tasks;
      throw e.toString();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final token = await sharedPreferencesService.getToken();
      if (token == null) {
        throw "User not authenticated";
      }
      http.Response res = await http
          .delete(Uri.parse("${Constants.backendUrl}/api/tasks/$id"), headers: {
        "Content-type": "application/json",
        "x-auth-token": token,
      });

      await taskLocalRepository.deleteTask(id);

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
