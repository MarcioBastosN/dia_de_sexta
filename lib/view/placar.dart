import 'package:dia_de_sexta/model/jogo.dart';
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
    const scalaDoTexto = 12.0;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  width: tamanhoWidth * 0.5,
                  height: tamanhoHeight,
                  color: Theme.of(context).copyWith().primaryColor,
                  child: Column(
                    children: [
                      Text(
                        jogo.equipe_1.toString(),
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        jogo.pontosEquipe_1.toString(),
                        style: GoogleFonts.getFont('Play'),
                        textScaleFactor: scalaDoTexto,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => jogo.adicionaPontosEqp1(context),
                            child: const Icon(Icons.add),
                          ),
                          ElevatedButton(
                            onPressed: () => jogo.removePontosEquipe_1(),
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: tamanhoWidth * 0.5,
                  height: tamanhoHeight,
                  color: Theme.of(context).copyWith().primaryColor,
                  child: Column(
                    children: [
                      Text(
                        jogo.equipe_2.toString(),
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        jogo.pontosEquipe_2.toString(),
                        style: GoogleFonts.getFont('Play'),
                        textScaleFactor: scalaDoTexto,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => jogo.adicionaPontosEqp2(context),
                            child: const Icon(Icons.add),
                          ),
                          ElevatedButton(
                            onPressed: () => jogo.removePontosEquipe_2(),
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
