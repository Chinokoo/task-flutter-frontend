import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signin_page.dart';
import 'package:frontend/features/auth/widgets/custom_auth_button.dart';
import 'package:frontend/features/auth/widgets/custom_auth_text_field.dart';

class SignupPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //key for form validation
  final formKey = GlobalKey<FormState>();

  //dispose method to dispose the controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpUser() {
    context.read<AuthCubit>().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim());
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
          } else if (state is AuthSignUp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Account created! Login Now.",
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
                    "Sign Up.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 10),
                  CustomAuthTextField(
                      controller: nameController,
                      hintText: "Enter your name",
                      obscureText: false),
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
                  CustomAuthButton(onTap: signUpUser, textButton: "Sign Up"),
                  //row for login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(SigninPage.route());
                        },
                        child: Text(
                          "Sign In",
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
