import 'package:dia_de_sexta/model/jogo.dart';
import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:dia_de_sexta/view/compoment/textFormCompoment.dart';
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
  final _focusP1 = FocusNode();
  final _focusP2 = FocusNode();
  final _focusPontos = FocusNode();
  Jogo? jogo;

  double _currentSliderValue = 10;

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

      Navigator.of(context).popAndPushNamed('placar');
    } else {
      _alertdialog(context);
    }
  }

  void inicioRapido() {
    Provider.of<Jogo>(context, listen: false).criarjgo(
      Jogo(
        equipe_1: "equipe_1",
        equipe_2: "equipe_2",
        pontosEquipe_1: 0,
        pontosEquipe_2: 0,
        fimJogo: 10,
      ),
    );
    Navigator.of(context).popAndPushNamed('placar');
  }

  void _alertdialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Ops!",
        mensagem: "Verifique os campos.",
        listaCompomentes: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      actions: [
        ButtonBar(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).popAndPushNamed('lista'),
              icon: const Icon(Icons.list),
            )
          ],
        )
      ],
    );

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => DialogComponent(
              mensagem: "Exit app",
              titulo: "Você deseja sair do Dia de sexta?",
              listaCompomentes: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Theme.of(context).copyWith().backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 48),
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
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                        bottom: Radius.circular(30),
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
                        // Slider(
                        //   value: _currentSliderValue,
                        //   max: 25,
                        //   min: 1,
                        //   divisions: 26,
                        //   label: _currentSliderValue.round().toString(),
                        //   onChanged: (double value) {
                        //     setState(() {
                        //       _currentSliderValue = value;
                        //     });
                        //   },
                        // ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => inicioRapido(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white30,
                                foregroundColor: Colors.amber,
                              ),
                              child: const Text('Jogo Rapido 10 pontos'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
