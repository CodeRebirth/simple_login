import 'package:flutter/material.dart';

import '../../core/const/color_const.dart';

class CustomTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: ColorConst.primaryColor,
      appBarTheme: const AppBarTheme(color: ColorConst.primaryColor, elevation: 0),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: ColorConst.primaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor), // Set the border color to black
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor), // Set the border color to black
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConst.buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding here
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: ColorConst.primaryColor, // Set the cursor color
        selectionHandleColor: ColorConst.primaryColor, // Set the selection handle color
      ),
      // Add more theme configurations as needed
    );
  }
}
