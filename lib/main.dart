import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/asset/custon/my_theme.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/home_screen/home_screen.dart';
import 'package:dia_de_sexta/view/splash_screen.dart';
import 'package:dia_de_sexta/view/view_lista_placar.dart';
import 'package:dia_de_sexta/view/view_placar.dart';
import 'package:dia_de_sexta/view/view_sobre.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dia de Sexta',
        theme: MyTheme().tema,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.placar: (context) =>
              const Placar(title: "Seu placar vai à:"),
          AppRoutes.lista: (context) => const ListaPlacar(),
          AppRoutes.sobre: (context) => const Sobre(),
        },
      ),
    );
  }
}
