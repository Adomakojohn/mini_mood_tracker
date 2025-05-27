import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(backgroundColor: Colors.teal, elevation: 0),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent,
    colorScheme: ColorScheme.dark(
      primary: Colors.tealAccent,
      secondary: Colors.teal,
      surface: Colors.grey[900]!,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900], elevation: 0),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}
