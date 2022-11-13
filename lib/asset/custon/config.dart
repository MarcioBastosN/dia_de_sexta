import 'package:flutter/material.dart';

Map<int, Color> _swatchOpcacity = {
  50: const Color.fromRGBO(34, 214, 21, .1),
  100: const Color.fromRGBO(34, 214, 21, .2),
  200: const Color.fromRGBO(34, 214, 21, .3),
  300: const Color.fromRGBO(34, 214, 21, .4),
  400: const Color.fromRGBO(34, 214, 21, .5),
  500: const Color.fromRGBO(34, 214, 21, .6),
  600: const Color.fromRGBO(34, 214, 21, .7),
  700: const Color.fromRGBO(34, 214, 21, .8),
  800: const Color.fromRGBO(34, 214, 21, .9),
  900: const Color.fromRGBO(34, 214, 21, 1),
};

abstract class CustonColor {
  static Color custonBackGroundColor = const Color.fromRGBO(34, 214, 21, .6);

  static MaterialColor custonPrimarySwatch =
      MaterialColor(0x22d615, _swatchOpcacity);
}
