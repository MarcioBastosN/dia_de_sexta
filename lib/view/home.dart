import 'package:dia_de_sexta/model/jogo.dart';
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
  void dispose() {
    _time1.dispose();
    _time2.dispose();
    _pontos.dispose();
    super.dispose();
  }

  void _iniciaJogo(context) {
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
        title: const Text("Ops!"),
        content: const Text('verifique os campos'),
        actions: <Widget>[
          FloatingActionButton(
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      // appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              'Dia de Sexta',
              style: TextStyle(fontSize: 32),
            ),
            const Text(
              'seu placar do Vôlei',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Time 1")),
                    controller: _time1,
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Time 2")),
                    controller: _time2,
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text("Quantos Ponto vai o Jogo?")),
                    maxLength: 2,
                    controller: _pontos,
                    keyboardType: TextInputType.phone,
                  ),
                  ElevatedButton(
                    onPressed: () => _iniciaJogo(context),
                    child: const Text(
                      'Iniciar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8.0,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: inicioRapido,
                  //   child: const Text('Jogo rapido, 10 pontos'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
