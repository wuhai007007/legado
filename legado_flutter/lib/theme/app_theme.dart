import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF42A5F5);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
  );

  // Reader themes
  static const Map<String, ReaderTheme> readerThemes = {
    'white': ReaderTheme(bgColor: Colors.white, textColor: Colors.black87, name: '白色'),
    'yellow': ReaderTheme(bgColor: Color(0xFFF5E6C8), textColor: Color(0xFF3E2723), name: '羊皮纸'),
    'green': ReaderTheme(bgColor: Color(0xFFC8E6C9), textColor: Color(0xFF1B5E20), name: '护眼绿'),
    'dark': ReaderTheme(bgColor: Color(0xFF37474F), textColor: Color(0xFFECEFF1), name: '深蓝'),
    'black': ReaderTheme(bgColor: Color(0xFF000000), textColor: Color(0xFF757575), name: '纯黑'),
  };
}

class ReaderTheme {
  final Color bgColor;
  final Color textColor;
  final String name;
  const ReaderTheme({required this.bgColor, required this.textColor, required this.name});
}
