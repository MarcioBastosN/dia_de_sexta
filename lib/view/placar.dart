import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Placar extends StatefulWidget {
  const Placar({super.key, required this.title});

  final String title;

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  int _pontosDireita = 0;
  int _pontosEsquerda = 0;
  int concluiJogo = 10;

  void _zerarContadores() {
    setState(() {
      _pontosDireita = 0;
      _pontosEsquerda = 0;
    });
  }

  void verificaPlacar(int valor) {
    if (valor == concluiJogo) {
      _alertdialog(context);
    }
  }

  void _alertdialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Fim de Jogo"),
        content: const Text('jogo encerado'),
        actions: <Widget>[
          FloatingActionButton(
            child: const Text("fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FloatingActionButton(
            child: const Text("Novo Jogo"),
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/');
            },
          )
        ],
      ),
    );
  }

  void _counterDireita(bool condicao) {
    setState(() {
      if (condicao) {
        if (_pontosDireita < concluiJogo) {
          _pontosDireita++;
          verificaPlacar(_pontosDireita);
        }
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
        if (_pontosEsquerda < concluiJogo) {
          _pontosEsquerda++;
          verificaPlacar(_pontosEsquerda);
        }
      } else {
        if (_pontosEsquerda > 0) {
          _pontosEsquerda--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jogo = ModalRoute.of(context)!.settings.arguments as Jogo;
    concluiJogo = jogo.fimJogo;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

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
                          jogo.equipe_1.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '$_pontosDireita',
                          // jogo.pontosEquipe_1.toString(),
                          style: GoogleFonts.getFont('Play'),
                          textScaleFactor: scalaDoTexto,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _counterDireita(true),
                              // onPressed: () => jogo.adicionaPontosEqp1(),
                              child: const Icon(Icons.add),
                            ),
                            ElevatedButton(
                              onPressed: () => _counterDireita(false),
                              // onPressed: () => jogo.removePontosEquipe_1(),
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
                          jogo.equipe_2.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
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
