import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/component/card_lista_placar.dart';
import 'package:dia_de_sexta/view/component/view_compartilhar/compartilhar_placar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'component/alert_exit.dart';

class ListaPlacar extends StatefulWidget {
  const ListaPlacar({super.key});

  @override
  State<ListaPlacar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListaPlacar> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        "Partidas : ${Provider.of<Jogo>(context, listen: false).tamanhoListaJogos().toString()}",
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );

    Provider.of<Jogo>(context, listen: false).loadDate();
    final listaJogo = Provider.of<Jogo>(context).listaJogos;

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: appBar,
        body: Provider.of<Jogo>(context, listen: false).tamanhoListaJogos() > 0
            ? AnimationLimiter(
                child: ListView.builder(
                    reverse: true,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: listaJogo.length,
                    itemBuilder: (context, int index) {
                      return Slidable(
                        key: ValueKey(listaJogo[index].id),
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Provider.of<Jogo>(context, listen: false)
                                    .removeJogo(listaJogo[index]);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              icon: Icons.delete,
                              label: 'Apagar',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompartilharPlacar(
                                      jogo: listaJogo[index],
                                    ),
                                  ),
                                );
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              icon: Icons.share,
                              label: 'Compartilhar',
                            ),
                          ],
                        ),
                        child: AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 1000),
                          delay: const Duration(milliseconds: 10),
                          position: 0,
                          child: FlipAnimation(
                            child: CardListaPlacar(
                              indexCard: (index + 1).toString(),
                              equipe1: Provider.of<Time>(context, listen: false)
                                  .retornaNomeTime(listaJogo[index].equipe_1!),
                              equipe2: Provider.of<Time>(context, listen: false)
                                  .retornaNomeTime(listaJogo[index].equipe_2!),
                              pontosEq1:
                                  listaJogo[index].pontosEquipe_1.toString(),
                              pontosEq2:
                                  listaJogo[index].pontosEquipe_2.toString(),
                              data: listaJogo[index].data.toString(),
                              tempo: listaJogo[index].tempoJogo!,
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Inicie uma partida ...."),
                      CircularProgressIndicator(),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
