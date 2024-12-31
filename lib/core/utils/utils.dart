import 'package:flutter/material.dart';

Color strengthenColor(Color color, double factor) {
  return Color.fromARGB(
    color.a.toInt(),
    (color.r * factor).clamp(0, 255).round(),
    (color.g * factor).clamp(0, 255).round(),
    (color.b * factor).clamp(0, 255).round(),
  );
}

//function to generate a list of dates for the current week
List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();

  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));

  return List.generate(
      7,
      (index) => startOfWeek
          .add(Duration(days: index))); // List.generate(7, generator)
}

String rgbToHex(Color color) {
  int r = (color.r * 255).round();
  int g = (color.g * 255).round();
  int b = (color.b * 255).round();
  return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hexColor) {
  // Remove the '#' if present
  final hex = hexColor.replaceAll('#', '');

  // Convert hex to integer
  final value = int.parse(hex, radix: 16);

  // Extract RGB values
  final r = ((value >> 16) & 0xFF) / 255.0;
  final g = ((value >> 8) & 0xFF) / 255.0;
  final b = ((value) & 0xFF) / 255.0;

  return Color.fromRGBO(
    (r * 255).round(),
    (g * 255).round(),
    (b * 255).round(),
    1.0,
  );
}
