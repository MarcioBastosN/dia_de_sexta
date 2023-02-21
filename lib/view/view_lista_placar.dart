import 'dart:io';

import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/view/component/card_lista_placar.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:dia_de_sexta/view/component/titulo_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

import 'component/alert_exit.dart';

class ListaPlacar extends StatefulWidget {
  const ListaPlacar({super.key});

  @override
  State<ListaPlacar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListaPlacar> {
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;

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
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      actions: [
        Provider.of<Jogo>(context, listen: false).equipe_1 != null
            ? PopupMenuButton(
                // color: Colors.blue,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).popAndPushNamed(AppRoutes.placar);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.games, color: Colors.black),
                          Text("Jogo"),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(),
      ],
    );

    Provider.of<Jogo>(context, listen: false).loadDate();
    final listaJogo = Provider.of<Jogo>(context).listaJogos;

    void compartilhar(BuildContext context, Jogo jogo) {
      String msn = "";
      String? origemImagem;
      if (jogo.pontosEquipe_1! > jogo.pontosEquipe_2!) {
        msn =
            "${Provider.of<Time>(context, listen: false).retornaNomeTime(jogo.equipe_1!)} jogou muito e venceu por ${jogo.pontosEquipe_1} x ${jogo.pontosEquipe_2}, a equipe ${Provider.of<Time>(context, listen: false).retornaNomeTime(jogo.equipe_2!)}";
      } else {
        msn =
            "${Provider.of<Time>(context, listen: false).retornaNomeTime(jogo.equipe_2!)} jogou muito e venceu por ${jogo.pontosEquipe_2} x ${jogo.pontosEquipe_1}, a equipe ${Provider.of<Time>(context, listen: false).retornaNomeTime(jogo.equipe_1!)}";
      }
      // aqui gera a imagem a ser compatilhada;
      screenshotController
          .captureFromWidget(
              InheritedTheme.captureAll(
                context,
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    // side: const BorderSide(color: Colors.cyan, width: 2),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    height: 300,
                    child: Column(
                      children: [
                        const TituloHome(),
                        CardListaPlacar(
                          indexCard: jogo.id.toString(),
                          equipe1: Provider.of<Time>(context, listen: false)
                              .retornaNomeTime(jogo.equipe_1!),
                          equipe2: Provider.of<Time>(context, listen: false)
                              .retornaNomeTime(jogo.equipe_2!),
                          pontosEq1: jogo.pontosEquipe_1.toString(),
                          pontosEq2: jogo.pontosEquipe_2.toString(),
                          data: jogo.data.toString(),
                          tempo: jogo.tempoJogo!,
                        ),
                        Text(msn),
                      ],
                    ),
                  ),
                ),
              ),
              delay: const Duration(microseconds: 300))
          .then((capturedImage) async {
        // final directory = (await getApplicationDocumentsDirectory()).path;
        if (capturedImage.isNotEmpty) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(capturedImage);
          setState(() {
            // caminho da imagem para o compartilhamento do plugin socialShare
            origemImagem = imagePath.path;
            // arquivo a sex exibido na mensagem
            _imageFile = capturedImage;
          });
        }
      }).whenComplete(() => {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => DialogComponent(
                    titulo: "Compartilhe seu placar!",
                    mensagem: SizedBox(
                      height: 160,
                      child: Center(
                          child: _imageFile != null
                              ? Image.memory(_imageFile!)
                              : const Text(
                                  "Ops!, a imagem ainda não foi carregada")),
                    ),
                    listaCompomentes: [
                      ElevatedButton(
                        child: const Text("Compartilhar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          SocialShare.shareOptions(
                            msn,
                            imagePath: origemImagem!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              });
    }

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: appBar,
        body: Provider.of<Jogo>(context, listen: false).tamanhoListaJogos() > 0
            ? ListView.builder(
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
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          icon: Icons.delete,
                          label: 'Apagar',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            compartilhar(context, listaJogo[index]);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          icon: Icons.share,
                          label: 'Compartilhar',
                        ),
                      ],
                    ),
                    child: CardListaPlacar(
                      indexCard: (index + 1).toString(),
                      equipe1: Provider.of<Time>(context, listen: false)
                          .retornaNomeTime(listaJogo[index].equipe_1!),
                      equipe2: Provider.of<Time>(context, listen: false)
                          .retornaNomeTime(listaJogo[index].equipe_2!),
                      pontosEq1: listaJogo[index].pontosEquipe_1.toString(),
                      pontosEq2: listaJogo[index].pontosEquipe_2.toString(),
                      data: listaJogo[index].data.toString(),
                      tempo: listaJogo[index].tempoJogo!,
                    ),
                  );
                })
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
