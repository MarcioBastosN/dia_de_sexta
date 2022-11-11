import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/placar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dia de Sexta',
        theme: ThemeData(
          primaryColor: Colors.black87,
          primarySwatch: Colors.lightBlue,
          backgroundColor: Colors.cyan,
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
          sliderTheme: const SliderThemeData(
            thumbColor: Colors.lightBlue,
            valueIndicatorColor: Colors.lightBlue,
            inactiveTrackColor: Colors.amber,
            inactiveTickMarkColor: Colors.white,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
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
        ),
        routes: {
          '/': (context) => const Home(),
          'placar': (context) => const Placar(title: "Seu Placar vai à:"),
          // 'lista': (context) => const ListaPlacar(),
        },
      ),
    );
  }
}
