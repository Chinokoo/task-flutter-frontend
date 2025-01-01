import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'task_cubit_state.dart';

class TaskCubit extends Cubit<TaskCubitState> {
  TaskCubit() : super(TaskCubitInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  TaskLocalRepository taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required DateTime dueDate,
  }) async {
    try {
      emit(TaskLoading());

      final task = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        dueDate: dueDate,
      );

      await taskLocalRepository.insertTask(task);

      emit(TaskSuccess());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<List<Object>> getTasks() async {
    try {
      emit(TaskLoading());
      final List<Task> tasks = await taskRemoteRepository.getTasks();

      emit(GetTaskSuccess(tasks));
      return tasks;
    } catch (e) {
      final List<Task>? tasks = await taskLocalRepository.getTasks();
      emit(TaskError(e.toString()));
      return tasks!;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      emit(TaskLoading());

      await taskRemoteRepository.deleteTask(id);
      await taskLocalRepository.deleteTask(id);

      emit(TaskSuccess());
    } catch (e) {
      throw e.toString();
    }
  }
}
