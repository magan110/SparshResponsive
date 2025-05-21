import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom theme extension for additional app-specific theme properties.
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color customShadowColor;
  final Color focusColor;
  final Color hoverColor;

  CustomThemeExtension({
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.customShadowColor,
    required this.focusColor,
    required this.hoverColor,
  });

  @override
  CustomThemeExtension copyWith({
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? customShadowColor,
    Color? focusColor,
    Color? hoverColor,
  }) {
    return CustomThemeExtension(
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor: shimmerHighlightColor ?? this.shimmerHighlightColor,
      customShadowColor: customShadowColor ?? this.customShadowColor,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      shimmerBaseColor: Color.lerp(shimmerBaseColor, other.shimmerBaseColor, t)!,
      shimmerHighlightColor: Color.lerp(shimmerHighlightColor, other.shimmerHighlightColor, t)!,
      customShadowColor: Color.lerp(customShadowColor, other.customShadowColor, t)!,
      focusColor: Color.lerp(focusColor, other.focusColor, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
    );
  }
}

/// A utility class that provides theme data for the application.
/// Supports both light and dark themes with proper accessibility features.
///
/// This class provides:
/// - Complete light and dark theme implementations
/// - Material 3 design support
/// - Accessibility features
/// - Consistent color usage
/// - Theme extensions
/// - Utility methods for common UI elements
class ThemeUtils {
  // Color constants for consistent usage across the app
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryLightBlue = Color(0xFF64B5F6);
  static const Color primaryDarkBlue = Color(0xFF1565C0);
  static const Color secondaryTeal = Color(0xFF26C6DA);
  static const Color secondaryDarkTeal = Color(0xFF00838F);
  static const Color accentOrange = Color(0xFFFFAB40);
  static const Color accentDarkOrange = Color(0xFFF57C00);
  static const Color errorRed = Color(0xFFE53935);
  static const Color errorRedDark = Color(
      0xFFB71C1C); // Dark variant for onErrorContainer
  static const Color successGreen = Color(0xFF43A047);
  static const Color warningAmber = Color(0xFFFFA000);

  // Background colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Text colors
  static const Color lightTextPrimary = Color(0xFF424242);
  static const Color lightTextSecondary = Color(0xFF616161);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  /// Returns the light theme data for the application.
  static ThemeData getLightTheme() {
    final customThemeExtension = getCustomThemeExtension(
        brightness: Brightness.light);

    return ThemeData(
      // Enable Material 3 design
      useMaterial3: true,

      // Primary color scheme
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        onPrimary: Colors.white,
        primaryContainer: primaryLightBlue.withOpacity(0.2),
        onPrimaryContainer: primaryDarkBlue,
        secondary: secondaryTeal,
        onSecondary: Colors.white,
        secondaryContainer: secondaryTeal.withOpacity(0.2),
        onSecondaryContainer: secondaryDarkTeal,
        tertiary: accentOrange,
        onTertiary: Colors.white,
        tertiaryContainer: accentOrange.withOpacity(0.2),
        onTertiaryContainer: accentDarkOrange,
        error: errorRed,
        onError: Colors.white,
        errorContainer: errorRed.withOpacity(0.2),
        onErrorContainer: errorRedDark,
        background: lightBackground,
        onBackground: lightTextPrimary,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        surfaceVariant: Colors.grey.shade100,
        onSurfaceVariant: lightTextSecondary,
        outline: Colors.grey.shade400,
        brightness: Brightness.light,
      ),

      // Typography
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        displayLarge: const TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: primaryBlue),
        displayMedium: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: primaryBlue),
        displaySmall: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue),
        headlineLarge: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600, color: lightTextPrimary),
        headlineMedium: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: lightTextPrimary),
        headlineSmall: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: lightTextPrimary),
        titleLarge: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: lightTextPrimary),
        titleMedium: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: lightTextPrimary),
        titleSmall: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: lightTextPrimary),
        bodyLarge: const TextStyle(fontSize: 16, color: lightTextSecondary),
        bodyMedium: const TextStyle(fontSize: 14, color: lightTextSecondary),
        bodySmall: const TextStyle(fontSize: 12, color: lightTextSecondary),
        labelLarge: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: primaryBlue),
        labelMedium: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: primaryBlue),
        labelSmall: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: primaryBlue),
      ).apply(
        // Enable font scaling for accessibility
        fontSizeFactor: 1.0,
        fontSizeDelta: 0.0,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        errorStyle: const TextStyle(color: errorRed, fontSize: 12),
        helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: lightSurface,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        clipBehavior: Clip.antiAlias,
      ),

      // Scaffold background color
      scaffoldBackgroundColor: lightBackground,

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 24,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryBlue,
        size: 24,
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade400;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.8);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.6);
          }
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.7);
          }
          return Colors.transparent; // Default unselected state
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: Colors.grey.shade400),
      ),

      // Radio button theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade400;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.8);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.6);
          }
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.7);
          }
          return Colors.transparent; // Default unselected state
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.05);
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return states.contains(MaterialState.selected)
                ? Colors.grey.shade400
                : Colors.grey.shade300;
          }
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.pressed)) {
              return primaryBlue.withOpacity(0.9);
            }
            if (states.contains(MaterialState.hovered)) {
              return primaryBlue.withOpacity(0.8);
            }
            if (states.contains(MaterialState.focused)) {
              return primaryBlue.withOpacity(0.9);
            }
            return primaryBlue;
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade300;
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.shade200;
          }
          if (states.contains(MaterialState.focused)) {
            return Colors.grey.shade200;
          }
          return Colors.grey.shade50;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return states.contains(MaterialState.selected)
                ? Colors.grey.shade400.withOpacity(0.5)
                : Colors.grey.shade300;
          }
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.pressed)) {
              return primaryBlue.withOpacity(0.6);
            }
            if (states.contains(MaterialState.hovered)) {
              return primaryBlue.withOpacity(0.5);
            }
            if (states.contains(MaterialState.focused)) {
              return primaryBlue.withOpacity(0.6);
            }
            return primaryBlue.withOpacity(0.5);
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade400;
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.shade400.withOpacity(0.8);
          }
          if (states.contains(MaterialState.focused)) {
            return Colors.grey.shade400.withOpacity(0.8);
          }
          return Colors.grey.shade300;
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.05);
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lightSurface,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      // Snackbar theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Add custom theme extensions
      extensions: [customThemeExtension],
    );
  }

  /// Returns the dark theme data for the application.
  static ThemeData getDarkTheme() {
    final customThemeExtension = getCustomThemeExtension(
        brightness: Brightness.dark);

    return ThemeData(
      // Enable Material 3 design
      useMaterial3: true,

      // Primary color scheme
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        onPrimary: Colors.white,
        primaryContainer: primaryLightBlue.withOpacity(0.15),
        onPrimaryContainer: Colors.white,
        secondary: secondaryTeal,
        onSecondary: Colors.white,
        secondaryContainer: secondaryTeal.withOpacity(0.15),
        onSecondaryContainer: Colors.white,
        tertiary: accentOrange,
        onTertiary: Colors.black,
        tertiaryContainer: accentOrange.withOpacity(0.15),
        onTertiaryContainer: Colors.white,
        error: errorRed,
        onError: Colors.white,
        errorContainer: errorRed.withOpacity(0.15),
        onErrorContainer: Colors.white,
        background: darkBackground,
        onBackground: darkTextPrimary,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceVariant: const Color(0xFF303030),
        onSurfaceVariant: darkTextSecondary,
        outline: Colors.grey.shade700,
        brightness: Brightness.dark,
      ),

      // Typography
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        displayLarge: const TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: primaryLightBlue),
        displayMedium: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: primaryLightBlue),
        displaySmall: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: primaryLightBlue),
        headlineLarge: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600, color: darkTextPrimary),
        headlineMedium: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: darkTextPrimary),
        headlineSmall: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleLarge: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleMedium: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleSmall: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: darkTextPrimary),
        bodyLarge: const TextStyle(fontSize: 16, color: darkTextSecondary),
        bodyMedium: const TextStyle(fontSize: 14, color: darkTextSecondary),
        bodySmall: const TextStyle(fontSize: 12, color: darkTextSecondary),
        labelLarge: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: primaryLightBlue),
        labelMedium: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: primaryLightBlue),
        labelSmall: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: primaryLightBlue),
      ).apply(
        // Enable font scaling for accessibility
        fontSizeFactor: 1.0,
        fontSizeDelta: 0.0,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLightBlue,
          side: const BorderSide(color: primaryLightBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLightBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLightBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        errorStyle: const TextStyle(color: errorRed, fontSize: 12),
        helperStyle: const TextStyle(color: darkTextSecondary, fontSize: 12),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF2A2A2A),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        clipBehavior: Clip.antiAlias,
      ),

      // Scaffold background color
      scaffoldBackgroundColor: darkBackground,

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 1,
        space: 24,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryLightBlue,
        size: 24,
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade700;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.8);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.6);
          }
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.7);
          }
          return Colors.transparent; // Default unselected state
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: Colors.grey.shade600),
      ),

      // Radio button theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade700;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.8);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.6);
          }
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.7);
          }
          return Colors.transparent; // Default unselected state
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.05);
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return states.contains(MaterialState.selected)
                ? Colors.grey.shade600
                : Colors.grey.shade700;
          }
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.pressed)) {
              return primaryBlue.withOpacity(0.9);
            }
            if (states.contains(MaterialState.hovered)) {
              return primaryBlue.withOpacity(0.8);
            }
            if (states.contains(MaterialState.focused)) {
              return primaryBlue.withOpacity(0.9);
            }
            return primaryBlue;
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade500;
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.shade500;
          }
          if (states.contains(MaterialState.focused)) {
            return Colors.grey.shade500;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return states.contains(MaterialState.selected)
                ? Colors.grey.shade700.withOpacity(0.5)
                : Colors.grey.shade800;
          }
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.pressed)) {
              return primaryBlue.withOpacity(0.6);
            }
            if (states.contains(MaterialState.hovered)) {
              return primaryBlue.withOpacity(0.5);
            }
            if (states.contains(MaterialState.focused)) {
              return primaryBlue.withOpacity(0.6);
            }
            return primaryBlue.withOpacity(0.5);
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade600;
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.shade600;
          }
          if (states.contains(MaterialState.focused)) {
            return Colors.grey.shade600;
          }
          return Colors.grey.shade700;
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.05);
          }
          if (states.contains(MaterialState.focused)) {
            return primaryBlue.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurface,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade900,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Add custom theme extensions
      extensions: [customThemeExtension],
    );
  }

  /// Returns the app theme based on the current brightness.
  /// This is a convenience method to use in MaterialApp.
  static ThemeData getAppTheme({Brightness brightness = Brightness.light}) {
    return brightness == Brightness.light ? getLightTheme() : getDarkTheme();
  }

  /// Sets the system UI overlay style based on the current brightness.
  /// This ensures proper status bar and navigation bar colors.
  static void setSystemUIOverlayStyle(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? darkBackground : lightBackground,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness
          .dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  /// Custom theme extension for additional app-specific theme properties.
  /// This allows for extending the theme with custom properties.
  static CustomThemeExtension getCustomThemeExtension(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return CustomThemeExtension(
      shimmerBaseColor: isDark ? const Color(0xFF262626) : const Color(
          0xFFE0E0E0),
      shimmerHighlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(
          0xFFF5F5F5),
      customShadowColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black
          .withOpacity(0.1),
      focusColor: isDark ? primaryLightBlue.withOpacity(0.2) : primaryBlue
          .withOpacity(0.1),
      hoverColor: isDark ? primaryLightBlue.withOpacity(0.1) : primaryBlue
          .withOpacity(0.05),
    );
  }

  /// Returns a custom container decoration for cards and panels based on the current brightness.
  static BoxDecoration getCardDecoration(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.2)
              : Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Returns a gradient decoration for headers and important elements based on the current brightness.
  static BoxDecoration getGradientDecoration(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [primaryBlue, primaryDarkBlue]
            : [primaryBlue, const Color(0xFF1976D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primaryBlue.withOpacity(isDark ? 0.2 : 0.3),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Returns a style for section titles based on the current brightness.
  static TextStyle getSectionTitleStyle(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: isDark ? primaryLightBlue : primaryBlue,
    );
  }

  /// Returns a style for section subtitles based on the current brightness.
  static TextStyle getSectionSubtitleStyle(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDark ? darkTextPrimary : lightTextPrimary,
    );
  }

  /// Returns a style for body text based on the current brightness.
  static TextStyle getBodyTextStyle(
      {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    return TextStyle(
      fontSize: 14,
      color: isDark ? darkTextSecondary : lightTextSecondary,
    );
  }

  /// Returns a decoration for input fields based on the current brightness.
  static InputDecoration getInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? primaryLightBlue : primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: TextStyle(
        color: isDark ? darkTextSecondary : Colors.grey.shade700,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
      ),
    );
  }

  /// Returns a decoration for buttons based on the current brightness.
  static ButtonStyle getElevatedButtonStyle({
    Brightness brightness = Brightness.light,
    bool isSecondary = false,
  }) {
    final isDark = brightness == Brightness.dark;
    final Color backgroundColor;

    if (isSecondary) {
      backgroundColor = isDark ? secondaryDarkTeal : secondaryTeal;
    } else {
      backgroundColor = isDark ? primaryDarkBlue : primaryBlue;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}