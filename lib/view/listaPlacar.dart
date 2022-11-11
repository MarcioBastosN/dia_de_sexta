import 'dart:ffi';
import 'dart:math';

import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaPlacar extends StatefulWidget {
  const ListaPlacar({super.key});

  @override
  State<ListaPlacar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListaPlacar> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(Provider.of<Jogo>(context, listen: false)
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

    return Scaffold(
      appBar: appBar,
      body: Provider.of<Jogo>(context).tamanhoListaJogos() > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: listaJogo.length,
              // itemCount: Provider.of<Jogo>(context).tamanhoListaJogos(),
              itemBuilder: (context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        elevation: 2.0,
                        color: Colors.orange,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(listaJogo[index].equipe_1.toString()),
                                Text(
                                    listaJogo[index].pontosEquipe_1.toString()),
                              ],
                            ),
                            Column(
                              children: [
                                Text(listaJogo[index].equipe_2.toString()),
                                Text(
                                    listaJogo[index].pontosEquipe_2.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       '${lista.listaJogos[index].equipe_2.toString()}',
                      //       style: const TextStyle(
                      //         fontSize: 20,
                      //       ),
                      //     ),
                      //     Text('Pontos: ${lista.listaJogos[index].pontosEquipe_2}'),
                      //   ],
                      // ),
                    ],
                  ),
                );
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("REACT NATIVE É MELHOR"),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<Jogo>(context, listen: false).createJogo(
          Jogo(
            equipe_1: "teste001",
            equipe_2: "teste002",
            pontosEquipe_1: Random().nextInt(4),
            pontosEquipe_2: Random().nextInt(3),
            fimJogo: 3,
          ),
        ),
        elevation: 10.0,
        child: const Icon(Icons.add),
      ),
    );
  }
}
