import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/view/component/sobre/dados_dev.dart';
import 'package:dia_de_sexta/view/component/sobre/edita_participantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
              children: const [
                DadosDev(),
                Padding(
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
