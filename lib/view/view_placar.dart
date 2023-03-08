import 'package:dia_de_sexta/controller/controller_placar_screen.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/component/mostrador_placar_compoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'component/alert_exit.dart';

class Placar extends StatefulWidget {
  const Placar({super.key});

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  ControllerPlacarScreen controllerPlacar = ControllerPlacarScreen();

  @override
  void initState() {
    // mantem a tela ativa
    Wakelock.enable();
    // define a orientacao da tela
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
    // inicia o timer
    controllerPlacar.disparaContadorTempo();

    super.initState();
  }

  @override
  void dispose() {
    // libera a tela ativa
    Wakelock.disable();
    // libera o timer
    controllerPlacar.cancelaContadorTempo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // inicia o jogo;
    Jogo jogo = Provider.of<Jogo>(context);
    // registra o tempo
    jogo.tempoJogo = controllerPlacar.tempoDaPartida.value;

    final menuItem_2 = PopupMenuItem(
      value: "Encerrar partida",
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Provider.of<Jogo>(context, listen: false).fecharPartida(context);
        },
        child: Row(
          children: const [
            Icon(Icons.edit_note_sharp),
            Text("Encerrar Partida"),
          ],
        ),
      ),
    );

// appBar
    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Seu placar vai à: ${jogo.pontosFimJogo.toString()} pontos"),
          GetX<ControllerPlacarScreen>(
            init: controllerPlacar,
            builder: (_) {
              return Text(controllerPlacar.tempoDaPartida.value);
            },
          ),
        ],
      ),
      actions: [
        ButtonBar(children: [
          PopupMenuButton(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry>[menuItem_2]),
        ])
      ],
    );

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        appBar: appBar,
        body: GetX<ControllerPlacarScreen>(
          init: controllerPlacar,
          builder: (_) {
            return Stack(
              children: [
                controllerPlacar.trocaLadoJogo.value
                    ? Row(
                        children: <Widget>[
                          PlacarComponent(
                            titulo: Provider.of<Time>(context, listen: false)
                                .retornaNomeTime(jogo.equipe_1!),
                            placar: jogo.pontosEquipe_1.toString(),
                            addPontosEquipe: "Equipe_1",
                            decrementaPontosEquipe: "Equipe_1",
                          ),
                          PlacarComponent(
                            titulo: Provider.of<Time>(context, listen: false)
                                .retornaNomeTime(jogo.equipe_2!),
                            placar: jogo.pontosEquipe_2.toString(),
                            addPontosEquipe: "Equipe_2",
                            decrementaPontosEquipe: "Equipe_2",
                          ),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          PlacarComponent(
                            titulo: Provider.of<Time>(context, listen: false)
                                .retornaNomeTime(jogo.equipe_2!),
                            placar: jogo.pontosEquipe_2.toString(),
                            addPontosEquipe: "Equipe_2",
                            decrementaPontosEquipe: "Equipe_2",
                          ),
                          PlacarComponent(
                            titulo: Provider.of<Time>(context, listen: false)
                                .retornaNomeTime(jogo.equipe_1!),
                            placar: jogo.pontosEquipe_1.toString(),
                            addPontosEquipe: "Equipe_1",
                            decrementaPontosEquipe: "Equipe_1",
                          ),
                        ],
                      ),
                // troca lado
                Positioned(
                  left: MediaQuery.of(context).size.width * .45,
                  top: (MediaQuery.of(context).size.height * .45) -
                      appBar.preferredSize.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => controllerPlacar.inverteLadoJogo(),
                        icon: Icon(
                          Icons.compare_arrows_rounded,
                          color: Theme.of(context).colorScheme.outlineVariant,
                          size: 48,
                        ),
                      ),
                      Text(
                        "Trocar",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
