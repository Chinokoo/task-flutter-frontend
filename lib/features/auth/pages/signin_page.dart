import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/auth/widgets/custom_auth_button.dart';
import 'package:frontend/features/auth/widgets/custom_auth_text_field.dart';

class SigninPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => SigninPage());

  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  //controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //key for form validation
  final formKey = GlobalKey<FormState>();

  //dispose method to dispose the controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInUser() {
    context.read<AuthCubit>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                )));
          } else if (state is AuthLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Logged in successfully!",
                  style: TextStyle(color: Colors.white),
                )));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  //signup title
                  Center(
                      child: const Text(
                    "Sign In.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 10),

                  CustomAuthTextField(
                      controller: emailController,
                      hintText: "Enter your email",
                      obscureText: false),
                  CustomAuthTextField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      obscureText: true),
                  //sized box for additional spacing
                  SizedBox(height: 10),
                  //signup button
                  CustomAuthButton(onTap: signInUser, textButton: "Log In"),
                  //row for login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(SignupPage.route());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
