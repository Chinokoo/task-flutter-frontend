import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final sharedPreferencesService = SharedPreferencesService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();
      if (userModel.token.isNotEmpty) {
        await authLocalRepository.insertUser(userModel);

        emit(AuthLoggedIn(userModel));

        await authLocalRepository.getUser();
      } else {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      }
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      final userModel = await authLocalRepository.getUser();
      if (userModel != null) {
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthError(e.toString()));
      }
      emit(AuthInitial());
      //
    }
  }

  void signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
          name: name, email: email, password: password);
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final userModel =
          await authRemoteRepository.signIn(email: email, password: password);

      await sharedPreferencesService.setToken(userModel.token);

      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
