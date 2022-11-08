import 'package:dia_de_sexta/provider/providerJogo.dart';
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
    final listJogos = Provider.of<ProviderJogo>(context);

    final appBar = AppBar(
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
      body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: listJogos.tamanhoListaJogos(),
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
                        '${listJogos.jogos[index].equipe_1}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text('Pontos: ${listJogos.jogos[index].pontosEquipe_1}'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${listJogos.jogos[index].equipe_2}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text('Pontos: ${listJogos.jogos[index].pontosEquipe_2}'),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
