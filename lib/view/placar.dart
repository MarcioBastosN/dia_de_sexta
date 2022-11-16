import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/mostrador_placar_compoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class Placar extends StatefulWidget {
  const Placar({super.key, required this.title});

  final String title;

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
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

    final appBar = AppBar(
      title: Text("${widget.title} ${jogo.fimJogo.toString()} pontos"),
      actions: [
        ButtonBar(children: [
          PopupMenuButton(
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
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
                      Icon(Icons.home),
                      Text("Home"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: "historico",
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popAndPushNamed(AppRoutes.lista);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.list),
                      Text("Historico"),
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
                    Navigator.of(context).popAndPushNamed(AppRoutes.lista);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.edit_note_sharp),
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

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => DialogComponent(
              titulo: "Você deseja sair ?",
              listaCompomentes: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).popAndPushNamed(AppRoutes.home),
                  },
                  child: const Text('Ir para o inicio'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sair'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: appBar,
        body: Row(
          children: <Widget>[
            PlacarComponent(
              titulo: jogo.equipe_1.toString(),
              placar: jogo.pontosEquipe_1.toString(),
              adciona: () => jogo.adicionaPontosEqp1(context),
              decrementa: () => jogo.removePontosEquipe_1(),
            ),
            PlacarComponent(
              titulo: jogo.equipe_2.toString(),
              placar: jogo.pontosEquipe_2.toString(),
              adciona: () => jogo.adicionaPontosEqp2(context),
              decrementa: () => jogo.removePontosEquipe_2(),
            ),
          ],
        ),
      ),
    );
  }
}
