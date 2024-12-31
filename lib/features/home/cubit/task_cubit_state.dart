part of 'task_cubit.dart';

sealed class TaskCubitState {
  const TaskCubitState();
}

final class TaskLoading extends TaskCubitState {}

final class TaskCubitInitial extends TaskCubitState {}

final class TaskSuccess extends TaskCubitState {}

final class GetTaskSuccess extends TaskCubitState {
  final List<dynamic> tasks;
  GetTaskSuccess(this.tasks);
}

final class TaskError extends TaskCubitState {
  final String message;
  const TaskError(this.message);
}
