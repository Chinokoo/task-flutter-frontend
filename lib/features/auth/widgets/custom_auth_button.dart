import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String textButton;
  final VoidCallback onTap;
  const CustomAuthButton(
      {super.key, required this.textButton, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      onPressed: onTap,
      child: Text(
        textButton,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
