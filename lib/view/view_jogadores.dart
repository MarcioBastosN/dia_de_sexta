import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:dia_de_sexta/view/component/jogadores/grid_jogadores.dart';
import 'package:dia_de_sexta/view/component/times/grid_times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'component/alert_exit.dart';

class ListaJogadores extends StatefulWidget {
  const ListaJogadores({super.key});

  @override
  State<ListaJogadores> createState() => _ListaJogadoresState();
}

class _ListaJogadoresState extends State<ListaJogadores> {
  final controllerFlip = FlipCardController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<Jogador>(context, listen: false).loadDate();
    Provider.of<Time>(context, listen: false).loadDate();
    super.initState();
  }

  bool verificaSorteio() {
    bool valida = false;

    if (Provider.of<Grupo>(context, listen: false)
        .verificaParticipantesDisponiveis(context)) {
      if (Provider.of<Jogador>(context).listaJogadores.length >= 2) {
        if (Provider.of<Time>(context).listaTimes.length <=
            Provider.of<Jogador>(context).listaJogadores.length) {
          valida = true;
        }
      }
    }

    return valida;
  }

  dicasSorteio(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DialogComponent(
        titulo: "Sorteio",
        mensagem: Text(
            "Para realizar o sorteio a quantidade de jogadores disponiveis deve ser maior ou igual a quantidade de times"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: FlipCard(
            rotateSide: RotateSide.bottom,
            controller: controllerFlip,
            onTapFlipping: true,
            frontWidget:
                Provider.of<Jogador>(context).tamanhoListaJogadores() == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Adicione Jogadores"),
                            Text(
                                "Necessario 2 ou mais jodadores para realizar o sorteio!"),
                          ],
                        ),
                      )
                    : GridJogadores(flip: controllerFlip),
            backWidget: Provider.of<Time>(context).tamanhoListaTimes() == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Adicione Times"),
                        Text("Crie 2 ou mais times para usalos no inicio!"),
                        Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  )
                : const GridTimes(),
          ),
        ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          overlayColor: Theme.of(context).colorScheme.secondary,
          children: [
            SpeedDialChild(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelBackgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                label: "Jogador",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Icon(
                  Icons.person_add,
                  color: Theme.of(context).colorScheme.background,
                ),
                onTap: () {
                  if (controllerFlip.state!.isFront != true) {
                    controllerFlip.flipcard().whenComplete(() =>
                        Provider.of<Jogador>(context, listen: false)
                            .addJogadorLista(context));
                  } else {
                    Provider.of<Jogador>(context, listen: false)
                        .addJogadorLista(context);
                  }
                }),
            SpeedDialChild(
                visible: Provider.of<Jogador>(context, listen: false)
                            .tamanhoListaJogadores() >=
                        2
                    ? true
                    : false,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelBackgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                label: "Time",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Icon(
                  Icons.gamepad,
                  color: Theme.of(context).colorScheme.background,
                ),
                onTap: () {
                  if (controllerFlip.state!.isFront == true) {
                    controllerFlip.flipcard().whenComplete(() =>
                        Provider.of<Time>(context, listen: false)
                            .addTimeLista(context));
                  } else {
                    Provider.of<Time>(context, listen: false)
                        .addTimeLista(context);
                  }
                }),
            // apagar registros grupos
            SpeedDialChild(
              visible: Provider.of<Jogador>(context, listen: false)
                          .tamanhoListaJogadores() >=
                      2
                  ? true
                  : false,
              backgroundColor: Colors.red,
              labelBackgroundColor: Colors.red,
              label: "Zerar times",
              labelStyle: const TextStyle(color: Colors.black),
              child: const Icon(Icons.refresh),
              onTap: () => Provider.of<Grupo>(context, listen: false)
                  .zerarTimes(context),
            ),
            SpeedDialChild(
              visible: verificaSorteio(),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              labelBackgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              label: "Sorteia Times",
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Icon(
                Icons.playlist_add_check_circle_outlined,
                color: Theme.of(context).colorScheme.background,
              ),
              onTap: () {},
              // => Provider.of<Grupo>(context, listen: false)
              //     .sorteiaTimes(context)
              //     .whenComplete(() {
              //   if (controllerFlip.state!.isFront == true) {
              //     controllerFlip.flipcard();
              //   }
              // }),
            ),
            SpeedDialChild(
              visible: !verificaSorteio(),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              labelBackgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              label: "Info",
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.background,
              ),
              onTap: () => dicasSorteio(context),
            ),
          ],
        ),
      ),
    );
  }
}
