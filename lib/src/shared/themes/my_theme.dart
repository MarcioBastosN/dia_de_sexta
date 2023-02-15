import 'package:flutter/material.dart';

const myTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: TextStyle(
    fontSize: 30,
  ),
);

final myOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: const BorderSide(width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
);
const myDividerTheme = DividerThemeData(thickness: 2.0);
final myPopupMenuTheme = PopupMenuThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
);
