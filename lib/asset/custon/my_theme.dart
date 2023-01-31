import 'package:flutter/material.dart';

class MyTheme {
  final tema = ThemeData(
      useMaterial3: true,
      primaryColor: Colors.black87, // define a cor padrao, cor do placar
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.cyan,
        onPrimary: Colors.white,
        secondary: Colors.blue,
        onSecondary: Colors.white,
        error: Colors.orange,
        onError: Colors.black,
        background: Colors.cyan,
        onBackground: Colors.white,
        surface: Colors.blue,
        onSurface: Colors.white,
      ),
      // primarySwatch: Colors.blue,
      textTheme: const TextTheme(
        // headline1:
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          // color: Colors.white,
        ),
        // headline4:
        headlineMedium: TextStyle(
          fontSize: 30,
        ),
        // bodyText2:
        bodyMedium: TextStyle(
            // color: Colors.red,
            ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.cyan,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.cyan,
        thickness: 2.0,
      ),
      scaffoldBackgroundColor: Colors.cyan,
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ));
}
