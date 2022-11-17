import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
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
  final _time1 = TextEditingController();
  final _time2 = TextEditingController();
  final _pontos = TextEditingController();
  final _pontosJogoRapido = TextEditingController();
  final _focusP1 = FocusNode();
  final _focusP2 = FocusNode();
  final _focusPontos = FocusNode();
  final _focusJogoRapido = FocusNode();
  Jogo? jogo;

  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
    _time1.dispose();
    _time2.dispose();
    _pontos.dispose();
    _focusPontos.dispose();
    _focusP1.dispose();
    _focusP2.dispose();
  }

  _iniciaJogo() {
    final eq1 = _time1.text.toString().trim();
    final eq2 = _time2.text.toString().trim();
    if (eq1.isNotEmpty &&
        eq2.isNotEmpty &&
        _pontos.text.toString().isNotEmpty) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: eq1,
          equipe_2: eq2,
          pontosEquipe_1: 0,
          pontosEquipe_2: 0,
          fimJogo: int.parse(_pontos.text.toString()),
        ),
      );

      Navigator.of(context).popAndPushNamed(AppRoutes.placar);
    } else {
      _alertdialog(context);
    }
  }

  void inicioRapido() {
    if (int.parse(_pontosJogoRapido.text.toString()) > 0) {
      Provider.of<Jogo>(context, listen: false).criarjgo(
        Jogo(
          equipe_1: "equipe_1",
          equipe_2: "equipe_2",
          pontosEquipe_1: 0,
          pontosEquipe_2: 0,
          fimJogo: int.parse(_pontosJogoRapido.text.toString()),
        ),
      );
      Navigator.of(context).popAndPushNamed(AppRoutes.placar);
    }
  }

  void _alertdialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Ops!",
        mensagem: const Text("Verifique os campos."),
        listaCompomentes: [
          ElevatedButton(
            child: const Text("fechar"),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _focusP1.requestFocus();
              });
            },
          ),
        ],
      ),
    );
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
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => DialogComponent(
              titulo: "Você deseja sair do Dia de sexta?",
              listaCompomentes: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    final media = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: Theme.of(context).copyWith().backgroundColor,
        body: SingleChildScrollView(
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormCompoment(
                            label: "Time 1",
                            controller: _time1,
                            inputType: TextInputType.text,
                            perfixIcon: Icons.people,
                            focus: _focusP1,
                            submit: () {
                              setState(() {
                                _focusP2.requestFocus();
                              });
                            },
                          ),
                          TextFormCompoment(
                            label: "Time 2",
                            controller: _time2,
                            inputType: TextInputType.text,
                            perfixIcon: Icons.people,
                            focus: _focusP2,
                            submit: () {
                              setState(() {
                                _focusPontos.requestFocus();
                              });
                            },
                          ),
                          TextFormCompoment(
                            label: "Quantos Pontos vai o Jogo?",
                            maxLength: 2,
                            controller: _pontos,
                            inputType: TextInputType.phone,
                            focus: _focusPontos,
                          ),

                          // button iniciar
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => _iniciaJogo(),
                                child: const Text(
                                  'Iniciar',
                                ),
                              ),
                            ),
                          ),
                          // divisor
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.cyan,
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "OU",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.cyan,
                                  thickness: 2.0,
                                ),
                              ),
                            ],
                          ),
                          // button jogo rapido
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.cyan,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: "Lista",
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).popAndPushNamed('lista');
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.list),
                              Text("Historico"),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Sobre",
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .popAndPushNamed(AppRoutes.sobre);
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
        ),
      ),
    );
  }
}
