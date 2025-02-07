import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3e65af),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFFE4EBFF),
  onSecondary: Color(0xFF3AB54A),
  error: Color(0xFFE74C3C),
  onError: Color(0xFFFFFFFF),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFF4A4A4A),
  onSurface: Color(0xFFD3D3D3),
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.interTextTheme(Typography.blackCupertino),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        lightColorScheme.primary, // Slightly darker shade for the button
      ),
      foregroundColor:
          WidgetStateProperty.all<Color>(Colors.white), // text color
      elevation: WidgetStateProperty.all<double>(5.0), // shadow
      padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Adjust as needed
        ),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  // colorScheme: darkColorScheme,
);