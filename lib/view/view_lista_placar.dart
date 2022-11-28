import 'dart:io';

import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/card_lista_placar.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/titulo_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

import 'compoment/alert_exit.dart';

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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
              "Partidas : ${Provider.of<Jogo>(context, listen: false).tamanhoListaJogos().toString()}"),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              Text(Provider.of<Jogo>(context, listen: false).tempoJogado()),
            ],
          ),
        ],
      ),
      actions: [
        Provider.of<Jogo>(context, listen: false).equipe_1 != null
            ? PopupMenuButton(
                color: Colors.blue,
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

    final listaJogo = Provider.of<Jogo>(context).listaJogos;
    Provider.of<Jogo>(context, listen: false).loadDate();

    void compartilhar(BuildContext context, Jogo jogo) {
      String msn = "";
      String? origemImagem;
      if (jogo.pontosEquipe_1! > jogo.pontosEquipe_2!) {
        msn =
            "${jogo.equipe_1} jogou muito e venceu por ${jogo.pontosEquipe_1} x ${jogo.pontosEquipe_2}, a equipe ${jogo.equipe_2}";
      } else {
        msn =
            "${jogo.equipe_2} jogou muito e venceu por ${jogo.pontosEquipe_2} x ${jogo.pontosEquipe_1}, a equipe ${jogo.equipe_1}";
      }
      // aqui gera a imagem a ser compatilhada;
      screenshotController
          .captureFromWidget(
              InheritedTheme.captureAll(
                context,
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Colors.cyan, width: 2),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    height: 250,
                    child: Column(
                      children: [
                        const TituloHome(),
                        CardListaPlacar(
                          indexCard: jogo.id.toString(),
                          equipe1: jogo.equipe_1.toString(),
                          equipe2: jogo.equipe_2.toString(),
                          pontosEq1: jogo.pontosEquipe_1.toString(),
                          pontosEq2: jogo.pontosEquipe_2.toString(),
                          data: jogo.data.toString(),
                          tempo: Provider.of<Jogo>(context, listen: false)
                              .retonaTempo(jogo.tempoJogo.toString()),
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
                    mensagem: Container(
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
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Apagar',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            compartilhar(context, listaJogo[index]);
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Compartilhar',
                        ),
                      ],
                    ),
                    child: CardListaPlacar(
                      indexCard: (index + 1).toString(),
                      equipe1: listaJogo[index].equipe_1.toString(),
                      equipe2: listaJogo[index].equipe_2.toString(),
                      pontosEq1: listaJogo[index].pontosEquipe_1.toString(),
                      pontosEq2: listaJogo[index].pontosEquipe_2.toString(),
                      data: listaJogo[index].data.toString(),
                      tempo: Provider.of<Jogo>(context, listen: false)
                          .retonaTempo(listaJogo[index].tempoJogo.toString()),
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
