import 'package:dia_de_sexta/controller/controller_home_screen.dart';
import 'package:dia_de_sexta/src/util/page_routes.dart';
import 'package:dia_de_sexta/src/util/routes.dart';
import 'package:dia_de_sexta/src/shared/themes/my_theme.dart';
import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  // injeção de dependencia com GetX
  Get.put<ControllerHomeScreen>(ControllerHomeScreen());
  // Get.lazyPut<ControllerHomeScreen>(() => ControllerHomeScreen());
  // --nao finalizado - refatorar varias classes

  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());

    if (inDebug) {
      return ErrorWidget(details.exception);
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        "Error:\n ${details.exception}",
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Definicoes(),
        ),
        ChangeNotifierProvider(
          create: (context) => Jogo(),
        ),
        ChangeNotifierProvider(
          create: (context) => Jogador(),
        ),
        ChangeNotifierProvider(
          create: (context) => Time(),
        ),
        ChangeNotifierProvider(
          create: (context) => Grupo(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smash',
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: AppRoutes.intro,
        getPages: AppPages.pages,
      ),
    );
  }
}
