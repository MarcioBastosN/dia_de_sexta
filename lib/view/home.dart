import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/alert_exit.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/entrada_jogo_simples.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pontosJogoRapido = TextEditingController();
  final _focusJogoRapido = FocusNode();

  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void inicioRapido() {
    if (int.parse(_pontosJogoRapido.text.toString()) > 0) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: "equipe_1",
          equipe_2: "equipe_2",
          fimJogo: int.parse(_pontosJogoRapido.text.toString()),
        ),
      );
      Navigator.of(context).popAndPushNamed(AppRoutes.placar);
    }
  }

  void _consultaPontosJogo(BuildContext context) {
    _focusJogoRapido.requestFocus();
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Placar",
        listaCompomentes: [
          TextFormCompoment(
            label: "Quantos Pontos vai o Jogo?",
            maxLength: 2,
            controller: _pontosJogoRapido,
            inputType: TextInputType.phone,
            focus: _focusJogoRapido,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                child: const Text("Iniciar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  inicioRapido();
                },
              ),
            ],
          ),
        ],
      ),
    );
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text: "Dia de ",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                            text: 'Sexta',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: [
                          TextSpan(text: "Seu placar do vôlei"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // parte de baixo
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // entrada de dados jogo simples
                      const EntradaJogoSimples(),
                      // divisor
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OU",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                      // button jogo rapido
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => _consultaPontosJogo(context),
                            child: const Text(
                              'Jogo Rapido',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                color: Colors.cyan,
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
