import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();

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

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      print(e.toString());
      emit(AuthError(e.toString()));
    }
  }
}
