import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacarComponent extends StatefulWidget {
  final String titulo;
  final String placar;
  final String addPontosEquipe;
  final String decrementaPontosEquipe;

  const PlacarComponent({
    super.key,
    required this.titulo,
    required this.placar,
    required this.addPontosEquipe,
    required this.decrementaPontosEquipe,
  });

  @override
  State<PlacarComponent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PlacarComponent> {
  bool animatedButton = false;
  @override
  Widget build(BuildContext context) {
    Jogo jogo = Provider.of<Jogo>(context, listen: false);

    Future<void> animatedButtonIncrement(BuildContext context) async {
      if (widget.addPontosEquipe.toString() == "Equipe_1") {
        jogo.adicionaPontosEqp1(context);
      } else {
        jogo.adicionaPontosEqp2(context);
      }

      setState(() => animatedButton = !animatedButton);
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => animatedButton = !animatedButton);
    }

    Future<void> animatedButtonDecrement(BuildContext context) async {
      if (widget.decrementaPontosEquipe.toString() == "Equipe_1") {
        jogo.removePontosEquipe_1();
      } else {
        jogo.removePontosEquipe_2();
      }

      setState(() => animatedButton = !animatedButton);
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => animatedButton = !animatedButton);
    }

    final media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width * .5,
      child: Container(
        color: Theme.of(context).copyWith().primaryColor,
        child: Column(
          children: [
            Text(
              widget.titulo,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              widget.placar,
              style: Theme.of(context).textTheme.headline1,
              // style: GoogleFonts.getFont('Play'),
              textScaleFactor: 1.5,
            ),
            // botoes
            SizedBox(
              child: animatedButton == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => animatedButtonIncrement(context),
                          child: const Icon(Icons.add),
                        ),
                        ElevatedButton(
                          onPressed: () => animatedButtonDecrement(context),
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "Placar alterado",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
