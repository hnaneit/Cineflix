import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primaryContainer: Color.fromARGB(255, 206, 206, 206),
    secondary: Color.fromARGB(255, 99, 99, 101),
    onPrimary: Color.fromARGB(255, 8, 8, 10),
    primary: Color.fromARGB(255, 201, 204, 209),
    onSecondary: Color.fromARGB(255, 226, 229, 236),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primaryContainer: Color.fromARGB(255, 38, 39, 41),
    secondary: Color.fromARGB(255, 178, 179, 183),
    onPrimary: Color.fromARGB(255, 222, 223, 225),
    primary: Color.fromARGB(255, 28, 28, 30),
    onSecondary: Color.fromARGB(255, 59, 61, 60),
  ),
);
