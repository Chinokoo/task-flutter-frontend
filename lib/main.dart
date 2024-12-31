import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signin_page.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/pages/home.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => TaskCubit()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state is AuthLoggedIn) {
          return HomePage();
        }
        return const SigninPage();
      }),
    );
  }
}
