import 'package:flutter/material.dart';
part 'color_schemes.g.dart';

const myTextTheme = TextTheme(
  displayLarge: TextStyle(fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(fontSize: 30),
);

final myOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: const BorderSide(width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
);
const myDividerTheme = DividerThemeData(thickness: 2.0);
final myPopupMenuTheme = PopupMenuThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  textTheme: myTextTheme,
  popupMenuTheme: myPopupMenuTheme,
  dividerTheme: myDividerTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimaryContainer,
      textStyle: const TextStyle(fontSize: 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  textTheme: myTextTheme,
  popupMenuTheme: myPopupMenuTheme,
  dividerTheme: myDividerTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimaryContainer,
      textStyle: const TextStyle(fontSize: 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
  ),
);
