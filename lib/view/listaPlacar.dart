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
    final lista = Provider.of<Jogo>(context);
    Jogo jogo = Jogo(
      equipe_1: "a",
      equipe_2: "b",
    );

    final appBar = AppBar(
      title: Text(lista.tamanhoListaJogos().toString()),
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

    return Scaffold(
      appBar: appBar,
      body: Provider.of<Jogo>(context).tamanhoListaJogos() > 0
          ? ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: Provider.of<Jogo>(context).tamanhoListaJogos(),
              itemBuilder: (context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "lista",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          // Text(
                          //     'Pontos: ${lista.listaJogos[index].pontosEquipe_1}'),
                        ],
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
              children: [
                Text(
                  "REACT NATIVE É MELHOR ${lista}",
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => jogo.createJogo(jogo),
        elevation: 10.0,
        child: const Icon(Icons.add),
      ),
    );
  }
}
