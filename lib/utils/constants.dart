// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';

//final String FASTAPI_URL = "http://api.webmonster.ca";
final String FASTAPI_URL = "http://localhost:8000";
final int TOKEN_REFRESH_TIME_MIN = 2; //14

// Constants class
class AppConstants 
{
  static const primaryColor = Color(0xFF0A2463);
  static const secondaryColor = Color(0xFF3A506B);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const sectionSpacing = 60.0;
  static const horizontalPadding = 100.0;
  static const heroHeight = 500.0;
  static const breakpoints = 
  {
    'sm': 600.0,
    'md': 900.0,
    'lg': 1200.0,
  };
}

// Theme configuration
class AppTheme 
{
  static ThemeData get theme => ThemeData
  (
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme
        (
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16, height: 1.6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData
        (
          style: ElevatedButton.styleFrom
          (
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        appBarTheme: AppBarTheme
        (
          backgroundColor: AppConstants.backgroundColor, // AppBar background color
        ),
        useMaterial3: true,
        cardTheme: CardTheme
        ( // Define card theme here
          color: Colors.white, // Background color of cards
          elevation: 0.5, // Optional: Add elevation for a shadow effect
          shape: RoundedRectangleBorder
          ( // Optional: Round card corners
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
}