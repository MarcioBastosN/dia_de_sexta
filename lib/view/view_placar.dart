import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
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

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Jogo jogo = Provider.of<Jogo>(context);

    void trocaLado() {
      setState(() {
        trocaLadoJogo = !trocaLadoJogo;
      });
    }

    final appBar = AppBar(
      title: Text("${widget.title} ${jogo.fimJogo.toString()} pontos"),
      actions: [
        ButtonBar(children: [
          PopupMenuButton(
            color: Colors.lightBlue,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
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
              ),
              PopupMenuItem(
                value: "Encerrar partida",
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<Jogo>(context, listen: false)
                        .fecharPartida(context);
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
              ),
            ],
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
                        titulo: jogo.equipe_1.toString(),
                        placar: jogo.pontosEquipe_1.toString(),
                        addPontosEquipe: "Equipe_1",
                        decrementaPontosEquipe: "Equipe_1",
                        // decrementa: () => jogo.removePontosEquipe_1(),
                      ),
                      PlacarComponent(
                        titulo: jogo.equipe_2.toString(),
                        placar: jogo.pontosEquipe_2.toString(),
                        addPontosEquipe: "Equipe_2",
                        decrementaPontosEquipe: "Equipe_2",
                        // adciona: () => jogo.adicionaPontosEqp2(context),
                        // decrementa: () => jogo.removePontosEquipe_2(),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      PlacarComponent(
                        titulo: jogo.equipe_2.toString(),
                        placar: jogo.pontosEquipe_2.toString(),
                        addPontosEquipe: "Equipe_2",
                        decrementaPontosEquipe: "Equipe_2",
                        // adciona: () => jogo.adicionaPontosEqp2(context),
                        // decrementa: () => jogo.removePontosEquipe_2(),
                      ),
                      PlacarComponent(
                        titulo: jogo.equipe_1.toString(),
                        placar: jogo.pontosEquipe_1.toString(),
                        addPontosEquipe: "Equipe_1",
                        decrementaPontosEquipe: "Equipe_1",
                        // decrementa: () => jogo.removePontosEquipe_1(),
                        // adciona: () => jogo.adicionaPontosEqp1(context),
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
