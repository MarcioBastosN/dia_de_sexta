import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      int? idJogadorTemp;
      Provider.of<Time>(context, listen: false)
          .carregaJogadoresDisponiveis(context);
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: "Selecione",
          listaCompomentes: [
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                labelText: "jogador(es)",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.cyan,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                labelStyle: TextStyle(
                  color: Colors.white60,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              items: Provider.of<Time>(context, listen: false)
                  .listaJogadoresDisponiveis,
              onChanged: (value) => {
                setState(() {
                  idJogadorTemp = value;
                }),
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<Jogador>(context, listen: false)
                    .jogadorPossuiTime(idJogadorTemp!)
                    .whenComplete(() {
                  Provider.of<Grupo>(context, listen: false)
                      .adicionarGrupo(Grupo(
                    idJogador: idJogadorTemp,
                    idTime: idTimeSelecionado,
                  ));
                });
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.7 / 3.5,
      ),
      itemCount: listaTimes.length,
      itemBuilder: (context, index) {
        return Scaffold(
          body: Card(
            color: Colors.blue,
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
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: SpeedDial(
            icon: Icons.menu,
            mini: true,
            overlayColor: Colors.blue.withAlpha(100),
            backgroundColor: Colors.cyan,
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
    );
  }
}
