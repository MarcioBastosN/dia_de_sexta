import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../dialog_component.dart';
import '../text_form_compoment.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridJogadores extends StatefulWidget {
  final FlipCardController? flip;

  const GridJogadores({super.key, this.flip});

  @override
  State<GridJogadores> createState() => _GridJogadoresState();
}

class _GridJogadoresState extends State<GridJogadores> {
  final _apelidoJogador = TextEditingController();
  final focusApelidoJogador = FocusNode();

  @override
  Widget build(BuildContext context) {
    final listaJogadores = context.watch<Jogador>().listaJogadores;

    // update jogador
    updateJogadorLista(BuildContext context, Jogador jogador) {
      _apelidoJogador.text = jogador.nome.toString();
      //   focusApelidoJogador.requestFocus();
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
                        context.read<Jogador>().editarJogador(jogador);
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
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 64.0),
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 4 / 3.1,
          ),
          itemCount: listaJogadores.length,
          itemBuilder: (context, index) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              body: AnimationConfiguration.staggeredGrid(
                duration: const Duration(milliseconds: 1000),
                position: 0,
                columnCount: 3,
                child: FlipAnimation(
                  child: Card(
                    color: listaJogadores[index].id != null
                        ? listaJogadores[index].possuiTime == 1
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      child: SizedBox(
                        height: 70,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 16),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(listaJogadores[index].nome!),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                overlayColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                direction: SpeedDialDirection.down,
                switchLabelPosition: verificaIndex(index),
                children: [
                  SpeedDialChild(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: "Editar",
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    onTap: () {
                      updateJogadorLista(context, listaJogadores[index]);
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: "Apagar",
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    visible:
                        listaJogadores[index].possuiTime != 1 ? true : false,
                    onTap: () {
                      if (listaJogadores[index].possuiTime != 1) {
                        context
                            .read<Jogador>()
                            .removeJogador(listaJogadores[index]);
                      }
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: "liberar",
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    visible:
                        listaJogadores[index].possuiTime == 1 ? true : false,
                    onTap: () {
                      // libera o jogador e remove do grupo
                      if (listaJogadores[index].possuiTime == 1) {
                        context.read<Jogador>().liberaJogadorId(
                            listaJogadores[index].id!, context);
                      }
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: "adicionar a um time",
                    // child: const Icon(Icons.refresh),
                    visible:
                        listaJogadores[index].possuiTime != 1 ? true : false,
                    onTap: () {
                      widget.flip!.flipcard();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
