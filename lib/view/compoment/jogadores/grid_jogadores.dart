import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialog_component.dart';
import '../text_form_compoment.dart';

class GridJogadores extends StatefulWidget {
  const GridJogadores({super.key});

  @override
  State<GridJogadores> createState() => _GridJogadoresState();
}

class _GridJogadoresState extends State<GridJogadores> {
  final _apelidoJogador = TextEditingController();
  final focusApelidoJogador = FocusNode();

  @override
  Widget build(BuildContext context) {
    final listaJogadores = Provider.of<Jogador>(context).listaJogadores;

    // update jogador
    updateJogadorLista(BuildContext context, Jogador jogador) {
      setState(() {
        focusApelidoJogador.requestFocus();
        _apelidoJogador.text = jogador.nome.toString();
      });
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Atualizar jogador',
          listaCompomentes: [
            TextFormCompoment(
              controller: _apelidoJogador,
              focus: focusApelidoJogador,
              label: "Nome",
              inputType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text("salvar"),
                    onPressed: () {
                      final player = _apelidoJogador.text.toString().trim();
                      if (player.isNotEmpty) {
                        jogador.nome = player;
                        Provider.of<Jogador>(context, listen: false)
                            .editarJogador(jogador);
                        _apelidoJogador.value =
                            const TextEditingValue(text: "");
                        focusApelidoJogador.unfocus();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 5 / 3,
      ),
      itemCount: listaJogadores.length,
      itemBuilder: (context, index) {
        return Card(
          color: listaJogadores[index].id != null ? Colors.green : Colors.red,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(listaJogadores[index].nome.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          updateJogadorLista(context, listaJogadores[index]);
                        },
                        child: const Icon(Icons.edit),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<Jogador>(context, listen: false)
                              .removeJogador(listaJogadores[index]);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
