import 'dart:io';
import 'dart:typed_data';

import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class CompartilharPlacar extends StatefulWidget {
  final Jogo? jogo;

  const CompartilharPlacar({super.key, this.jogo});

  @override
  State<CompartilharPlacar> createState() => _CompartilharPlacarState();
}

class _CompartilharPlacarState extends State<CompartilharPlacar> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // area a capturada
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: sizeScreen.width,
                height: sizeScreen.height * .4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(24),
                    bottomStart: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // const TituloHome(),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.headlineLarge!.fontSize,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      context.read<Time>().retornaNomeTime(
                                          widget.jogo!.equipe_1!),
                                    ),
                                    Text(
                                      widget.jogo!.pontosEquipe_1!.toString(),
                                      textScaleFactor: 5,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      context.read<Time>().retornaNomeTime(
                                          widget.jogo!.equipe_2!),
                                    ),
                                    Text(
                                      widget.jogo!.pontosEquipe_2!.toString(),
                                      textScaleFactor: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.jogo!.tempoJogo!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // botao para gerar a captura de tela
            ElevatedButton(
              child: const Text("Compartilhar"),
              onPressed: () async {
                await screenshotController
                    .capture(delay: const Duration(milliseconds: 100))
                    .then((Uint8List? image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath =
                      await File('${directory.path}/image.png').create();
                  await imagePath.writeAsBytes(image!);

                  SocialShare.shareOptions(
                    "Smash",
                    imagePath: imagePath.path,
                  );
                }).catchError((onError) {
                  // print(onError);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
