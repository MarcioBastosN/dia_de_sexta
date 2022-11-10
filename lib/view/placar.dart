import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:dia_de_sexta/view/compoment/mostradorPlacarCompoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Placar extends StatefulWidget {
  const Placar({super.key, required this.title});

  final String title;

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    Jogo jogo = Provider.of<Jogo>(context);

    final appBar = AppBar(
      title: Text("${widget.title} ${jogo.fimJogo.toString()} pontos"),
      // actions: [
      //   ButtonBar(children: [
      //     IconButton(
      //         onPressed: () => Navigator.of(context).popAndPushNamed('lista'),
      //         icon: const Icon(Icons.list))
      //   ])
      // ],
    );

    final tamanhoWidth = MediaQuery.of(context).size.width;
    final tamanhoHeight =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height);

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => DialogComponent(
              mensagem: "Exit app",
              titulo: "Você deseja sair ?",
              listaCompomentes: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).popAndPushNamed('/'),
                  },
                  child: const Text('Ir para o inicio'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
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
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  PlacarComponent(
                    tamanhoHeight: tamanhoHeight,
                    tamanhoWidth: tamanhoWidth * 0.5,
                    titulo: jogo.equipe_1.toString(),
                    placar: jogo.pontosEquipe_1.toString(),
                    adciona: () => jogo.adicionaPontosEqp1(context),
                    decrementa: () => jogo.removePontosEquipe_1(),
                  ),
                  PlacarComponent(
                    tamanhoHeight: tamanhoHeight,
                    tamanhoWidth: tamanhoWidth * 0.5,
                    titulo: jogo.equipe_2.toString(),
                    placar: jogo.pontosEquipe_2.toString(),
                    adciona: () => jogo.adicionaPontosEqp2(context),
                    decrementa: () => jogo.removePontosEquipe_2(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
