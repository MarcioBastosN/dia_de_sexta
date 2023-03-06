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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(children: [
          DefaultTextStyle(
            style: const TextStyle(fontSize: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DadosDev(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Exibir tela de introdução:"),
                    Switch(
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2.0,
                    child: EditaParticipante(),
                  ),
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
