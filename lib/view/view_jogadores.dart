import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/jogadores/grid_jogadores.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:dia_de_sexta/view/compoment/times/grid_times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'compoment/alert_exit.dart';

class ListaJogadores extends StatefulWidget {
  const ListaJogadores({super.key});

  @override
  State<ListaJogadores> createState() => _ListaJogadoresState();
}

class _ListaJogadoresState extends State<ListaJogadores> {
  final _nomeJogador = TextEditingController();
  final focusJogador = FocusNode();

  final _nomeTime = TextEditingController();
  final focusTime = FocusNode();

  @override
  void dispose() {
    _nomeJogador.dispose();
    focusJogador.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<Jogador>(context, listen: false).loadDate();
    Provider.of<Time>(context, listen: false).loadDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// adicona jogador
    addJogadorLista(BuildContext context) {
      setState(() => focusJogador.requestFocus());
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Registrar jogador',
          listaCompomentes: [
            TextFormCompoment(
              controller: _nomeJogador,
              focus: focusJogador,
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
                      final player = _nomeJogador.text.toString().trim();
                      if (player.isNotEmpty) {
                        Provider.of<Jogador>(context, listen: false)
                            .adicionarJogador(
                              Jogador(
                                nome: player,
                              ),
                            )
                            .whenComplete(() =>
                                Provider.of<Jogador>(context, listen: false)
                                    .loadDate());
                        _nomeJogador.value = const TextEditingValue(text: "");
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

    addTimeLista(BuildContext context) {
      setState(() => focusTime.requestFocus());
      showDialog(
        context: context,
        builder: (context) => DialogComponent(
          titulo: 'Registrar time',
          listaCompomentes: [
            TextFormCompoment(
              controller: _nomeTime,
              focus: focusTime,
              label: "Nome do time",
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
                      final time = _nomeTime.text.toString().trim();
                      if (time.isNotEmpty) {
                        Provider.of<Time>(context, listen: false)
                            .adicionarTime(
                              Time(
                                nome: time,
                              ),
                            )
                            .whenComplete(() =>
                                Provider.of<Time>(context, listen: false)
                                    .loadDate());
                        _nomeTime.value = const TextEditingValue(text: "");
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

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Provider.of<Jogador>(context, listen: false)
                            .tamanhoListaJogadores() ==
                        0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Adicione Jogadores"),
                            Text(
                                "Necessario 2 ou mais jodadores para formar times!"),
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      )
                    : const GridJogadores(),
              ),
              const Expanded(child: GridTimes()),
            ],
          ),
        ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          overlayColor: Colors.blue.withAlpha(100),
          children: [
            SpeedDialChild(
              backgroundColor: Colors.cyan,
              labelBackgroundColor: Colors.cyan,
              label: "Jogador",
              labelStyle: const TextStyle(color: Colors.black),
              child: const Icon(Icons.person_add),
              onTap: () => addJogadorLista(context),
            ),
            SpeedDialChild(
              visible: Provider.of<Jogador>(context, listen: false)
                          .tamanhoListaJogadores() >=
                      2
                  ? true
                  : false,
              backgroundColor: Colors.cyan,
              labelBackgroundColor: Colors.cyan,
              label: "Time",
              labelStyle: const TextStyle(color: Colors.black),
              child: const Icon(Icons.gamepad),
              onTap: () => addTimeLista(context),
            ),
          ],
        ),
      ),
    );
  }
}
