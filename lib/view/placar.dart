import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/mostradorPlacarCompoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Placar extends StatefulWidget {
  const Placar({super.key, required this.title});

  final String title;

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Jogo jogo = Provider.of<Jogo>(context);

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );

    final appBar = AppBar(
      title: Text(widget.title),
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

    return Scaffold(
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
    );
  }
}
