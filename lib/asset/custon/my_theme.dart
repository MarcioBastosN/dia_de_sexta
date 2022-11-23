import 'package:flutter/material.dart';

class MyTheme {
  final tema = ThemeData(
      primaryColor: Colors.black87, // define a cor padrao, cor do placar
      backgroundColor: Colors.cyan, //cor de fundo da aplicação
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
