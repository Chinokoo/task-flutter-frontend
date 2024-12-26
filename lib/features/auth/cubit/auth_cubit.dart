import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final sharedPreferencesService = SharedPreferencesService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();

      emit(AuthLoggedIn(userModel));

      return;
    } catch (e) {
      emit(AuthError(e.toString()));
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

      if (userModel.token.isNotEmpty) {
        await sharedPreferencesService.setToken(userModel.token);
      }

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      print(e.toString());
      emit(AuthError(e.toString()));
    }
  }
}
