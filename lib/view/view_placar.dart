import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/compoment/mostrador_placar_compoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'compoment/alert_exit.dart';

class Placar extends StatefulWidget {
  const Placar({super.key, required this.title});

  final String title;

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  bool trocaLadoJogo = false;

  int tempoJogo = 0;
  String? tempoDaPartida;

  @override
  void initState() {
    // mantem a tela ativa
    Wakelock.enable();
    // define a orientacao da tela
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
    // inicia o timer
    Provider.of<Jogo>(context, listen: false).disparaTempo();

    super.initState();
  }

  @override
  void dispose() {
    // libera a tela ativa
    Wakelock.disable();
    // libera o timer
    Provider.of<Jogo>(context, listen: false).cancelaContador();
    super.dispose();
  }

  // formata o tempo de jogo para exibir na tela
  String formataTempo(int tempo) {
    int nim = 0;
    int sec = 0;
    if (tempo > 60) {
      do {
        tempo = tempo - 60;
        if (tempo > 1) {
          nim++;
        }
      } while (tempo > 60);
    }
    sec = tempo;
    setState(() {
      tempoDaPartida = "$nim m $sec s";
    });
    return "$nim m $sec s";
  }

  @override
  Widget build(BuildContext context) {
    // inicia o jogo;
    Jogo jogo = Provider.of<Jogo>(context);
    // registra o tempo
    jogo.tempoJogo = tempoDaPartida;

    // inverte o placar de lado
    void trocaLado() {
      setState(() => trocaLadoJogo = !trocaLadoJogo);
    }

    final menuItem_1 = PopupMenuItem(
      value: "Home",
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed(AppRoutes.home);
        },
        child: Row(
          children: const [
            Icon(
              Icons.home,
              color: Colors.black,
            ),
            Text("Home"),
          ],
        ),
      ),
    );

    final menuItem_2 = PopupMenuItem(
      value: "Encerrar partida",
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Provider.of<Jogo>(context, listen: false).fecharPartida(context);
        },
        child: Row(
          children: const [
            Icon(
              Icons.edit_note_sharp,
              color: Colors.black,
            ),
            Text("Encerrar Partida"),
          ],
        ),
      ),
    );

// app bar
    final appBar = AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("${widget.title} ${jogo.pontosFimJogo.toString()} pontos"),
          Text(formataTempo(Provider.of<Jogo>(context, listen: true).time)),
        ],
      ),
      actions: [
        ButtonBar(children: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) =>
                Provider.of<Jogo>(context, listen: false).equipe_1 != null
                    ? <PopupMenuEntry>[menuItem_1, menuItem_2]
                    : <PopupMenuEntry>[menuItem_1],
          ),
        ])
      ],
    );

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            trocaLadoJogo == true
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
                    onPressed: () => trocaLado(),
                    icon: const Icon(
                      Icons.compare_arrows_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const Text(
                    "Trocar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
