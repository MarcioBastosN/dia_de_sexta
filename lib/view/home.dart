import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final appBar = AppBar(
      title: Text(widget.title),
    );

    final tamanhoWidth = MediaQuery.of(context).size.width;
    final tamanhoHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    const scalaDoTexto = 12.0;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: tamanhoWidth * 0.5,
                    height: tamanhoHeight,
                    color: Theme.of(context).copyWith().primaryColor,
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
                    color: Theme.of(context).copyWith().primaryColor,
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.red,
        backgroundColor: Colors.cyanAccent,
        onPressed: _zerarContadores,
        child: const Icon(
          Icons.restart_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
