import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.light;

  String toggleTheme(bool isOnOROff){
    String darkOrLight;
    themeMode = isOnOROff ? ThemeMode.light : ThemeMode.dark;
    darkOrLight = isOnOROff ? "Light Mode ": "Dark Mode ";
    notifyListeners();

    return darkOrLight;

  }
}

class Themes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    appBarTheme: const AppBarTheme(color: Colors.grey),

  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Color(0xffD6521B)),
  );
}
