import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/provider/providerJogo.dart';
import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/placar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => ProviderJogo(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => Jogo(),
        // ),
      ],
      child: MaterialApp(
        title: 'Dia de Sexta',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => Home(),
          'placar': (context) => const Placar(title: 'Dia de Sexta'),
        },
        // home: const Placar(title: 'Dia de Sexta'),
      ),
    );
  }
}
