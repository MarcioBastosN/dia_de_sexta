import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

    bool verificaIndex(int index) {
      if (index % 3 < 2) {
        return true;
      } else {
        return false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 4 / 3,
        ),
        itemCount: listaJogadores.length,
        itemBuilder: (context, index) {
          return Scaffold(
            body: Card(
              color: listaJogadores[index].id != null
                  ? listaJogadores[index].possuiTime == 1
                      ? Colors.blueGrey
                      : Colors.blue
                  : Colors.red,
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                child: SizedBox(
                  height: 70,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text(listaJogadores[index].nome.toString()),
                          Text(listaJogadores[index].possuiTime == 1
                              ? "Indisponivel"
                              : "Disponivel"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SpeedDial(
              icon: Icons.menu,
              mini: true,
              overlayColor: Colors.blue.withAlpha(100),
              backgroundColor: Colors.cyan,
              direction: SpeedDialDirection.down,
              switchLabelPosition: verificaIndex(index),
              children: [
                SpeedDialChild(
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "Editar",
                  child: const Icon(Icons.edit),
                  onTap: () {
                    updateJogadorLista(context, listaJogadores[index]);
                  },
                ),
                SpeedDialChild(
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "Apagar",
                  child: const Icon(Icons.delete),
                  visible: listaJogadores[index].possuiTime != 1 ? true : false,
                  onTap: () {
                    if (listaJogadores[index].possuiTime != 1) {
                      Provider.of<Jogador>(context, listen: false)
                          .removeJogador(listaJogadores[index]);
                    }
                  },
                ),
                SpeedDialChild(
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "liberar",
                  child: const Icon(Icons.refresh),
                  visible: listaJogadores[index].possuiTime == 1 ? true : false,
                  onTap: () {
                    // libera o jogador e remove do grupo
                    if (listaJogadores[index].possuiTime == 1) {
                      Provider.of<Jogador>(context, listen: false)
                          .liberaJogadorId(listaJogadores[index].id!, context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
