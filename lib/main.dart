import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return MaterialApp(
      title: 'Dia de Sexta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dia de Sexta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pontosDireita = 0;
  int _pontosEsquerda = 0;

  void _zerarContadores() {
    setState(() {
      _pontosDireita = 0;
      _pontosEsquerda = 0;
    });
  }

  void _counterDireita(bool condicao) {
    setState(() {
      if (condicao) {
        _pontosDireita++;
      } else {
        if (_pontosDireita > 0) {
          _pontosDireita--;
        }
      }
    });
  }

  void _counterEsquerda(bool condicao) {
    setState(() {
      if (condicao) {
        _pontosEsquerda++;
      } else {
        if (_pontosEsquerda > 0) {
          _pontosEsquerda--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tamanhoWidth = MediaQuery.of(context).size.width;
    final tamanhoHeight = MediaQuery.of(context).size.height;
    const scalaDoTexto = 12.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  width: tamanhoWidth * 0.5,
                  height: tamanhoHeight,
                  color: const Color.fromARGB(155, 11, 28, 208),
                  child: Column(
                    children: [
                      Text(
                        '$_pontosDireita',
                        style: GoogleFonts.getFont('Play'),
                        textScaleFactor: scalaDoTexto,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => _counterDireita(true),
                            child: const Icon(Icons.add),
                          ),
                          ElevatedButton(
                            onPressed: () => _counterDireita(false),
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: tamanhoWidth * 0.5,
                  height: tamanhoHeight,
                  color: const Color.fromARGB(155, 18, 208, 11),
                  child: Column(
                    children: [
                      Text(
                        '$_pontosEsquerda',
                        style: GoogleFonts.getFont('Play'),
                        textScaleFactor: scalaDoTexto,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => _counterEsquerda(true),
                            child: const Icon(Icons.add),
                          ),
                          ElevatedButton(
                            onPressed: () => _counterEsquerda(false),
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: _zerarContadores,
            //   child: const Text('Restart'),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _zerarContadores,
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
