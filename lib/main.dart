import 'package:dia_de_sexta/view/home.dart';
import 'package:dia_de_sexta/view/placar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dia de Sexta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => Home(),
        'placar': (context) => const Placar(title: 'Dia de Sexta'),
      },
      // home: const Placar(title: 'Dia de Sexta'),
    );
  }
}
