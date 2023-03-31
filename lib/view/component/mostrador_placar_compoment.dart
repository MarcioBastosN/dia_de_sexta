import 'package:dia_de_sexta/controller/controller_placar_component.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  ControllerPlacarComponent controllerPlacar = ControllerPlacarComponent();
  @override
  Widget build(BuildContext context) {
    Jogo jogo = Provider.of<Jogo>(context, listen: false);

    animatedButtonIncrement(BuildContext context) {
      if (widget.addPontosEquipe.toString() == "Equipe_1") {
        jogo.adicionaPontosEqp1(context);
      } else {
        jogo.adicionaPontosEqp2(context);
      }
      controllerPlacar.trocaStatusBotao();
    }

    animatedButtonDecrement(BuildContext context) {
      if (widget.decrementaPontosEquipe.toString() == "Equipe_1") {
        jogo.removePontosEquipe_1();
      } else {
        jogo.removePontosEquipe_2();
      }
      controllerPlacar.trocaStatusBotao();
    }

    final media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width * .5,
      child: DefaultTextStyle(
        style: const TextStyle(),
        overflow: TextOverflow.ellipsis,
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.titulo,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.placar,
                  style: Theme.of(context).textTheme.displayLarge,
                  textScaleFactor: 2.5,
                ),
              ),
              // botoes
              GetX<ControllerPlacarComponent>(
                init: controllerPlacar,
                builder: (_) {
                  return SizedBox(
                    child: controllerPlacar.animatedButton.value == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                onPressed: () =>
                                    animatedButtonIncrement(context),
                                child: const Icon(Icons.add),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                onPressed: () =>
                                    animatedButtonDecrement(context),
                                child: const Icon(Icons.remove),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              "Placar alterado",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
