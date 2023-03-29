import 'package:dia_de_sexta/src/util/routes.dart';
import 'package:dia_de_sexta/view/home_screen/home_screen.dart';
import 'package:dia_de_sexta/view/splash_screen.dart';
import 'package:dia_de_sexta/view/view_intro.dart';
import 'package:dia_de_sexta/view/view_lista_placar.dart';
import 'package:dia_de_sexta/view/view_placar.dart';
import 'package:dia_de_sexta/view/view_sobre.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.intro,
      page: () => const IntroScreen(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.placar,
      page: () => const Placar(),
    ),
    GetPage(
      name: AppRoutes.lista,
      page: () => const ListaPlacar(),
    ),
    GetPage(
      name: AppRoutes.sobre,
      page: () => const Sobre(),
    ),
  ];
}
