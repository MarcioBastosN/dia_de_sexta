import 'dart:ffi';
import 'dart:math';

import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ListaPlacar extends StatefulWidget {
  const ListaPlacar({super.key});

  @override
  State<ListaPlacar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListaPlacar> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Partidas Disputadas: " +
          Provider.of<Jogo>(context, listen: false)
              .tamanhoListaJogos()
              .toString()),
      actions: [
        ButtonBar(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).popAndPushNamed('/'),
              icon: const Icon(Icons.home),
            )
          ],
        )
      ],
    );

    final listaJogo = Provider.of<Jogo>(context).listaJogos;

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => DialogComponent(
              mensagem: "Exit app",
              titulo: "Você deseja sair ?",
              listaCompomentes: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).popAndPushNamed('/'),
                  },
                  child: const Text('Ir para o inicio'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sair'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: appBar,
        body: Provider.of<Jogo>(context).tamanhoListaJogos() > 0
            ? ListView.builder(
                reverse: true,
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8.0),
                itemCount: listaJogo.length,
                itemBuilder: (context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2.0,
                            color: Theme.of(context).copyWith().backgroundColor,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(listaJogo[index]
                                            .equipe_1
                                            .toString()),
                                        Text(listaJogo[index]
                                            .pontosEquipe_1
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(listaJogo[index]
                                            .equipe_2
                                            .toString()),
                                        Text(listaJogo[index]
                                            .pontosEquipe_2
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Ainda não tem jogo"),
                ],
              ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => Provider.of<Jogo>(context, listen: false).createJogo(
        //     Jogo(
        //       equipe_1: "teste001",
        //       equipe_2: "teste002",
        //       pontosEquipe_1: Random().nextInt(10),
        //       pontosEquipe_2: Random().nextInt(10),
        //       fimJogo: 10,
        //     ),
        //   ),
        //   elevation: 10.0,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
