import 'package:dia_de_sexta/model/jogo.dart';
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

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    super.initState();
  }

  @override
  void dispose() {
    _time1.dispose();
    _time2.dispose();
    _pontos.dispose();
    super.dispose();
  }

  void _iniciaJogo() {
    final eq1 = _time1.text.toString().trim();
    final eq2 = _time2.text.toString().trim();
    if (eq1.isNotEmpty && eq2.isNotEmpty) {
      Provider.of<Jogo>(context, listen: false).iniciaJogo(
        eq1,
        eq2,
        int.parse(_pontos.text.toString()),
      );
      Navigator.of(context).popAndPushNamed('placar');
    } else {
      _alertdialog(context);
    }
  }

  void inicioRapido() {
    Provider.of<Jogo>(context, listen: false).iniciaJogo(
      "equipe_1",
      "equipe_2",
      10,
    );
    Navigator.of(context).popAndPushNamed('placar');
  }

  void _alertdialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Ops!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: const Text('verifique os campos'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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

    return Scaffold(
      // appBar: appBar,
      backgroundColor: Colors.cyan,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 46,
                    ),
                    children: [
                      TextSpan(
                        text: "Dia de ",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: 'Sexta',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: "Seu placar do vôlei",
                      ),
                    ])),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormCompoment(
                    label: "Time 1",
                    controller: _time1,
                    inputType: TextInputType.text,
                    perfixIcon: Icons.person,
                  ),
                  TextFormCompoment(
                    label: "Time 2",
                    controller: _time2,
                    inputType: TextInputType.text,
                    perfixIcon: Icons.person,
                  ),
                  TextFormCompoment(
                    label: "Quantos Pontos vai o Jogo?",
                    maxLength: 2,
                    controller: _pontos,
                    inputType: TextInputType.phone,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _iniciaJogo(),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
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
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                        child: const Text(
                          'Jogo Rapido 10 pontos',
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
    );
  }
}
