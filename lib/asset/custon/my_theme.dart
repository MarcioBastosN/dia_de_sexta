import 'package:flutter/material.dart';

class MyTheme {
  final tema = ThemeData(
    primaryColor: Colors.black87,
    backgroundColor: Colors.cyan,
    primarySwatch: Colors.blue,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 30,
        color: Colors.white,
      ),
    ),
    // sliderTheme: const SliderThemeData(
    //   thumbColor: Colors.lightBlue,
    //   valueIndicatorColor: Colors.lightBlue,
    //   inactiveTrackColor: Colors.amber,
    //   inactiveTickMarkColor: Colors.white,
    //   valueIndicatorTextStyle: TextStyle(
    //     color: Colors.white,
    //   ),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
