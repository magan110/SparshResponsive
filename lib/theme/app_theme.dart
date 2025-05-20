import 'package:flutter/material.dart';

/// AppTheme class that defines the application's theme based on the DSR Entry screen design
class AppTheme {
  // Primary colors
  static const Color primaryColor = Color.fromARGB(255, 33, 150, 243); // Blue accent color
  static const Color secondaryColor = Colors.teal;
  static const Color accentColor = Color(0xFF3F51B5); // Indigo accent

  // Background colors
  static const Color scaffoldBackgroundColor = Color(0xFFF5F7FA); // Light background
  static const Color cardColor = Colors.white;

  // Text colors
  static const Color primaryTextColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color hintTextColor = Color(0xFFAAAAAA);

  // Status colors
  static const Color successColor = Colors.green;
  static const Color warningColor = Color(0xFFFFA000); // Amber
  static const Color errorColor = Colors.redAccent;

  // Border and divider colors
  static const Color borderColor = Color(0xFFE0E0E0);

  // Button colors
  static const Color primaryButtonColor = Color.fromARGB(255, 33, 150, 243);
  static const Color secondaryButtonColor = Colors.teal;
  static const Color dangerButtonColor = Colors.redAccent;

  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Section header decoration
  static BoxDecoration sectionHeaderDecoration = BoxDecoration(
    color: const Color(0xFFF5F7FA),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    ),
    border: Border(
      bottom: BorderSide(color: Colors.grey.shade200, width: 1),
    ),
  );

  // App bar theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    ),
  );

  // Text theme
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      letterSpacing: 0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: primaryTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: secondaryTextColor,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  );

  // Input decoration theme
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: errorColor, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    isCollapsed: false,
  );

  // Elevated button theme
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      elevation: 0,
    ),
  );

  // Outlined button theme
  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: accentColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );

  // Dropdown button style
  static ButtonStyle dropdownButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(3),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    foregroundColor: MaterialStateProperty.all(primaryTextColor),
  );

  // Card theme
  static CardTheme cardTheme = CardTheme(
    color: cardColor,
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );

  // Dialog theme
  static DialogTheme dialogTheme = DialogTheme(
    backgroundColor: cardColor,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );

  // Create the complete theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: appBarTheme,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    // No dropdown button theme in this Flutter version
    cardTheme: cardTheme,
    dialogTheme: dialogTheme,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: scaffoldBackgroundColor,
      surface: cardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: primaryTextColor,
      onBackground: primaryTextColor,
      onError: Colors.white,
    ),
  );

  // Helper methods for consistent styling

  // Section card builder
  static Widget buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: sectionHeaderDecoration,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          // Section content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Standard text field builder
  static Widget buildTextField(
    String hintText, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      style: textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: maxLines > 1
            ? const Icon(
                Icons.edit_note,
                color: primaryColor,
              )
            : null,
      ),
      validator: validator,
    );
  }

  // Date field builder
  static Widget buildDateField(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: primaryColor,
              size: 22,
            ),
            onPressed: onTap,
          ),
        ),
      ),
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Dropdown field builder
  static Widget buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemText,
    String? hint,
    String? Function(T?)? validator,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
            value: value,
            onChanged: onChanged,
            hint: Text(
              hint ?? 'Select',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            style: textTheme.bodyLarge,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemText(item),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            validator: validator,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  // Label builder
  static Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        text,
        style: textTheme.titleLarge,
      ),
    );
  }
}
