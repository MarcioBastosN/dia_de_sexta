import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/view/compoment/alert_exit.dart';
import 'package:dia_de_sexta/view/compoment/entrada_jogo_list_jogadores.dart';
import 'package:dia_de_sexta/view/compoment/titulo_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
    // defini orientação
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => AlertExit().showExitPopup(context),
      child: SizedBox(
        height: media.height,
        width: media.width,
        child: Stack(children: [
          Column(
            children: [
              const Expanded(
                child: TituloHome(),
              ),
              // parte de baixo - select e inicio
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      EntradaListajogadores(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // PopupMenu
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: "Sobre",
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(AppRoutes.sobre);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline),
                          Text("Sobre"),
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
