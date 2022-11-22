import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/card_lista_placar.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

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
          Text(
              "Tempo: ${Provider.of<Jogo>(context, listen: true).tempoJogado()}"),
        ],
      ),
      actions: [
        PopupMenuButton(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popAndPushNamed(AppRoutes.placar);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.games,
                      color: Colors.black,
                    ),
                    Text("Jogo"),
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
            barrierDismissible: true,
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

    void _compartilhar(BuildContext context, Jogo jogo) {
      // aqui gera a imagem a ser compatilhada;

      String msn = "";
      if (jogo.pontosEquipe_1! > jogo.pontosEquipe_2!) {
        msn =
            "${jogo.equipe_1} jogou muito e venceu por ${jogo.pontosEquipe_1} x ${jogo.pontosEquipe_2}, a equipe ${jogo.equipe_2}";
      } else {
        "${jogo.equipe_2} jogou muito e venceu por ${jogo.pontosEquipe_2} x ${jogo.pontosEquipe_1}, a equipe ${jogo.equipe_1}";
      }

      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => DialogComponent(
          titulo: "Compartilhe seu placar!",
          mensagem: Text(msn),
          listaCompomentes: [
            ElevatedButton(
              child: const Text("Compartilhar"),
              onPressed: () {
                Navigator.of(context).pop();
                //without an image
                SocialShare.shareOptions(msn);
              },
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.cyan,
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
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _compartilhar(context, listaJogo[index]);
                          },
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
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
                      tempo: Provider.of<Jogo>(context)
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
