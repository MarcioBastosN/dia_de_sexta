import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/view/component/sobre/dados_dev.dart';
import 'package:dia_de_sexta/view/component/sobre/edita_participantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool? loadSplash = false;

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        loadSplash = prefs.getBool("loadSpalsh");
      });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            top: 60,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        Switch(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: loadSplash!,
                          onChanged: (bool value) {
                            _prefs.then((SharedPreferences prefs) {
                              prefs.setBool("loadSpalsh", !loadSplash!);
                            }).whenComplete(() {
                              setState(() {
                                loadSplash = !loadSplash!;
                              });
                            });
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
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: PopupMenuButton(
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
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
