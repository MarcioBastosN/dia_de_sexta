import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
      title: Text(
          "Partidas Disputadas: ${Provider.of<Jogo>(context, listen: false).tamanhoListaJogos().toString()}"),
      actions: [
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
            Provider.of<Jogo>(context, listen: false).jogoEncerado != true
                ? PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).popAndPushNamed(AppRoutes.placar);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.games),
                          Text("Jogo"),
                        ],
                      ),
                    ),
                  )
                : PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.list),
                          Text("Lista"),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );

    final listaJogo = Provider.of<Jogo>(context).listaJogos;
    Provider.of<Jogo>(context, listen: false).loadDate();

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
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.cyan,
        body: Provider.of<Jogo>(context).tamanhoListaJogos() > 0
            ? ListView.builder(
                reverse: true,
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8.0),
                itemCount: listaJogo.length,
                itemBuilder: (context, int index) {
                  return Slidable(
                    key: ValueKey(listaJogo[index].id),
                    startActionPane: const ActionPane(
                      motion: StretchMotion(),
                      // motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: null,
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: null,
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2.0,
                              color:
                                  Theme.of(context).copyWith().backgroundColor,
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.lightBlue,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(listaJogo[index]
                                              .equipe_1
                                              .toString()),
                                          Text(listaJogo[index]
                                              .pontosEquipe_1
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(listaJogo[index]
                                              .equipe_2
                                              .toString()),
                                          Text(listaJogo[index]
                                              .pontosEquipe_2
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Inicie uma partida ...."),
                  CircularProgressIndicator(),
                ],
              ),
      ),
    );
  }
}
