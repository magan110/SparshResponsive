import 'package:flutter/material.dart';

/// A utility class that provides theme data for screens that need UI improvements.
/// This theme will be applied to all screens except HomeScreen.
class ThemeUtils {
  /// Returns the theme data for screens that need UI improvements.
  static ThemeData getAppTheme() {
    return ThemeData(
      // Primary color scheme
      primaryColor: const Color.fromARGB(255, 33, 150, 243), // Match dsr_entry color
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 33, 150, 243), // Match dsr_entry color
        primary: const Color.fromARGB(255, 33, 150, 243),
        secondary: const Color(0xFF26C6DA), // Teal accent
        tertiary: const Color(0xFFFFAB40), // Orange accent
        background: const Color(0xFFF5F7FA), // Match dsr_entry background
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      
      // Typography
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF424242)),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF424242)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF616161)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF616161)),
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      
      // Scaffold background color
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 24,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(0xFF1E88E5),
        size: 24,
      ),
    );
  }
  
  /// Returns a custom container decoration for cards and panels
  static BoxDecoration getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  /// Returns a gradient decoration for headers and important elements
  static BoxDecoration getGradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF1E88E5),
          Color(0xFF1976D2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1E88E5).withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  /// Returns a style for section titles
  static TextStyle getSectionTitleStyle() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E88E5),
    );
  }
  
  /// Returns a style for section subtitles
  static TextStyle getSectionSubtitleStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF424242),
    );
  }
}
