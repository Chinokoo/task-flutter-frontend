import 'package:flutter/material.dart';

Color strengthenColor(Color color, double factor) {
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.a.toInt(), r, g, b);
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