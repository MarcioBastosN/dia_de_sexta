import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../dialog_component.dart';
import '../text_form_compoment.dart';

class GridTimes extends StatefulWidget {
  const GridTimes({super.key});

  @override
  State<GridTimes> createState() => _GridTimesState();
}

class _GridTimesState extends State<GridTimes> {
  final nomeTime = TextEditingController();
  final focusTime = FocusNode();

  @override
  void initState() {
    Provider.of<Grupo>(context, listen: false).loadDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listaTimes = Provider.of<Time>(context).listaTimes;

// edita o nome do Time
    editaNomeTime(BuildContext context, Time time) {
      setState(() {
        nomeTime.text = time.nome!;
        focusTime.requestFocus();
      });
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Qual novo nome do seu Time?',
          listaCompomentes: [
            TextFormCompoment(
              controller: nomeTime,
              focus: focusTime,
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
                      final player = nomeTime.text.toString().trim();
                      if (player.isNotEmpty) {
                        Provider.of<Time>(context, listen: false)
                            .editarNomeTime(
                              Time(
                                id: time.id!,
                                nome: player,
                              ),
                            )
                            .whenComplete(() =>
                                Provider.of<Time>(context, listen: false)
                                    .loadDate());
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

// adiciona um jogador ao time
// deve retornar apenas a lista de jogadores disponiveis
    selecionaJogador(BuildContext context, int idTime) {
      int? jogadorId;
      String? nomeJogador;
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: "Selecione um Jogador",
          listaCompomentes: [
            DropdownSearch<String>(
              items: Provider.of<Jogador>(context, listen: false)
                  .getNomejogadoresDisponiveis(),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Jogador",
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
                  ),
                ),
              ),
              onChanged: (String? value) {
                // atribui o valor selecionado
                setState(() {
                  nomeJogador = value!;
                  jogadorId = Provider.of<Jogador>(context, listen: false)
                      .retornaIdJogador(value);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // altera o status do jogador
                Provider.of<Jogador>(context, listen: false).editarJogador(
                  Jogador(
                    id: jogadorId,
                    nome: nomeJogador,
                    possuiTime: 1,
                  ),
                );
                Provider.of<Jogador>(context, listen: false).loadDate();
                // salva o registro do time
                Provider.of<Grupo>(context, listen: false).adicionarGrupo(Grupo(
                  idJogador: jogadorId,
                  idTime: idTime,
                ));
                Navigator.of(context).pop();
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
        childAspectRatio: 4 / 3.5,
      ),
      itemCount: listaTimes.length,
      itemBuilder: (context, index) {
        // carrega a lista de jogadores de um grupo
        List<Grupo> grupo = Provider.of<Grupo>(context, listen: false)
            .jogadoresTimes(listaTimes[index].id!);
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
                      Text(
                        listaTimes[index].nome!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: Provider.of<Grupo>(context, listen: false)
                        .qtdjogadoresTime(listaTimes[index].id!),
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Row(
                          children: [
                            Text("${grupo[index].idJogador!}"),
                            Text(
                              Provider.of<Jogador>(context, listen: false)
                                  .retornaNomejogador(grupo[index].idJogador!),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    },
                  ),
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
                onTap: () => editaNomeTime(context, listaTimes[index]),
              ),
              SpeedDialChild(
                visible: Provider.of<Jogador>(context)
                        .getNomejogadoresDisponiveis()
                        .isEmpty
                    ? false
                    : true,
                labelStyle: const TextStyle(color: Colors.black),
                label: "Novo Jogador",
                child: const Icon(Icons.person_add),
                onTap: () => selecionaJogador(context, listaTimes[index].id!),
              ),
              SpeedDialChild(
                labelStyle: const TextStyle(color: Colors.black),
                label: "Apagar",
                child: const Icon(Icons.delete),
                onTap: () => {
                  // liberar os jogadores
                  // apagar todos os registros de jogadores
                  Provider.of<Time>(context, listen: false)
                      .removeTime(listaTimes[index])
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
