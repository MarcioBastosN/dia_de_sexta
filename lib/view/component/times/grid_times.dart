import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../dialog_component.dart';
import 'lista_jogadores_time.dart';

class GridTimes extends StatefulWidget {
  const GridTimes({super.key});

  @override
  State<GridTimes> createState() => _GridTimesState();
}

class _GridTimesState extends State<GridTimes> {
  @override
  void initState() {
    context.read<Grupo>().loadDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listaTimes = context.watch<Time>().listaTimes;

// Selecionar Jogadores para um time
    selecionarJogadoresTime(BuildContext context, int idTimeSelecionado) {
      List<Jogador>? jogadoresTemp;
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: "Selecione Jogador(es)",
          listaCompomentes: [
            MultiSelectDialogField(
              title: const Text("Jogadores"),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              selectedColor: Theme.of(context).colorScheme.secondary,
              selectedItemsTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              items: context
                  .read<Jogador>()
                  .getListaJogadoresDisponiveis()
                  .map((e) => MultiSelectItem(e, e.nome!))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                jogadoresTemp = values;
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 1º marca o jogador como indisponivel
                context
                    .read<Jogador>()
                    .jogadorPossuiTime(jogadoresTemp!)
                    .whenComplete(() {
                  // adiciona a relacao do jogador ao Time
                  context
                      .read<Grupo>()
                      .adicionarGrupo(jogadoresTemp!, idTimeSelecionado);

                  // atualiza a quantidade de participantes do time
                  context.read<Time>().incrementaQtdParticipantesTime(
                      idTimeSelecionado, jogadoresTemp!.length);
                });
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 64.0),
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.7 / 3.5,
          ),
          itemCount: listaTimes.length,
          itemBuilder: (context, index) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              body: AnimationConfiguration.staggeredGrid(
                duration: const Duration(milliseconds: 1000),
                position: 0,
                columnCount: 2,
                child: FlipAnimation(
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, top: 8, bottom: 8, left: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  listaTimes[index].nome!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child:
                              ListajogadoresTime(timeId: listaTimes[index].id!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndTop,
              floatingActionButton: SpeedDial(
                icon: Icons.menu,
                mini: true,
                overlayColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                direction: SpeedDialDirection.down,
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
                    onTap: () =>
                        context.read<Time>().editaNomeTime(listaTimes[index]),
                  ),
                  SpeedDialChild(
                    visible: context
                            .watch<Jogador>()
                            .getListaJogadoresDisponiveis()
                            .isEmpty
                        ? false
                        : true,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: "Jogador",
                    child: Icon(
                      Icons.person_add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    onTap: () =>
                        selecionarJogadoresTime(context, listaTimes[index].id!),
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
                    visible: context.watch<Time>().listaTimes.length > 2
                        ? true
                        : false,
                    onTap: () => {
                      context
                          .read<Time>()
                          .removeTimeEParticipantes(listaTimes[index], context)
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
