import 'package:flutter/material.dart';

final ThemeData calendarAppTheme = ThemeData(
  // Primary color (used for app bar, buttons)
  primaryColor: const Color(0xFF3366FF), // bright blue
  // Use Material 3 design (optional)
  useMaterial3: true,

  // Scaffold background
  scaffoldBackgroundColor: const Color(0xFFF5F7FA), // very light gray-blue
  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3366FF),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3366FF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 3,
    ),
  ),

  // TextButton theme (e.g., "Register", "Login" links)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF3366FF),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Input decoration theme (text fields)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF3366FF), width: 2),
    ),
  ),

  // BottomNavigationBar theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF3366FF),
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),

  // FloatingActionButton theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3366FF),
    foregroundColor: Colors.white,
  ),
);
