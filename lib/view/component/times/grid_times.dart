import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
    Provider.of<Grupo>(context, listen: false).loadDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listaTimes = Provider.of<Time>(context).listaTimes;

// Selecionar Jogadores para um time
    selecionarJogadoresTime(BuildContext context, int idTimeSelecionado) {
      List<Jogador>? jogadoresTemp;
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: "Selecione",
          listaCompomentes: [
            MultiSelectDialogField(
              decoration: const BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              selectedColor: Colors.blue,
              selectedItemsTextStyle: const TextStyle(
                color: Colors.white,
              ),
              items: Provider.of<Time>(context, listen: false)
                  .loadDisponiveis(context)
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
                Provider.of<Jogador>(context, listen: false)
                    .jogadorPossuiTime(jogadoresTemp!)
                    .whenComplete(() {
                  Provider.of<Grupo>(context, listen: false)
                      .adicionarGrupo(jogadoresTemp!, idTimeSelecionado)
                      .whenComplete(() {
                    Provider.of<Time>(context, listen: false)
                        .atualizaParticipantes(idTimeSelecionado);
                  });
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
            body: Card(
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListajogadoresTime(timeId: listaTimes[index].id!),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: SpeedDial(
              icon: Icons.menu,
              mini: true,
              overlayColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              direction: SpeedDialDirection.down,
              children: [
                SpeedDialChild(
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "Editar",
                  child: const Icon(Icons.edit),
                  onTap: () => Provider.of<Time>(context, listen: false)
                      .editaNomeTime(context, listaTimes[index]),
                ),
                SpeedDialChild(
                  visible: Provider.of<Jogador>(context)
                          .getListaJogadoresDisponiveis()
                          .isEmpty
                      ? false
                      : true,
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "Jogador",
                  child: const Icon(Icons.person_add),
                  onTap: () =>
                      selecionarJogadoresTime(context, listaTimes[index].id!),
                ),
                SpeedDialChild(
                  labelStyle: const TextStyle(color: Colors.black),
                  label: "Apagar",
                  child: const Icon(Icons.delete),
                  visible: Provider.of<Time>(context).listaTimes.length > 2
                      ? true
                      : false,
                  onTap: () => {
                    Provider.of<Time>(context, listen: false)
                        .removeTime(listaTimes[index], context)
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
