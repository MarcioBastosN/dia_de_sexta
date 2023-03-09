import 'package:dia_de_sexta/controller/controller_intro_screen.dart';
import 'package:dia_de_sexta/src/util/routes.dart';
import 'package:dia_de_sexta/view/component/sobre/dados_dev.dart';
import 'package:dia_de_sexta/view/component/sobre/edita_participantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  ControllerIntroScreen splashController = ControllerIntroScreen();

  @override
  void initState() {
    splashController.getLoadSplash();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Card(
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(16),
                      topEnd: Radius.circular(16),
                      bottomStart: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Smash",
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        indent: 120.0,
                        endIndent: 120.0,
                        thickness: 2.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Smash é um nome que se refere ao ataque mais forte e rapido do volêi, que sugere força e velocidade.",
                          textAlign: TextAlign.justify,
                          textScaleFactor: 1.3,
                          softWrap: true,
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const DadosDev(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Exibir tela de introdução:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetX<ControllerIntroScreen>(
                        init: splashController,
                        builder: (_) {
                          return Switch(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: splashController.loadSplash.value,
                            onChanged: (bool value) {
                              splashController.updateLoadSplash(
                                  newValue: !splashController.loadSplash.value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Card(
                child: EditaParticipante(),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
