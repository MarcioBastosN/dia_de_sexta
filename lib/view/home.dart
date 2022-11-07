import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final _time1 = TextEditingController();
  final _time2 = TextEditingController();
  final _pontos = TextEditingController();

  void _iniciaJogo(context) {
    final eq1 = _time1.text.toString().trim();
    final eq2 = _time2.text.toString().trim();
    if (eq1.isNotEmpty && eq2.isNotEmpty) {
      Jogo jogo = Provider.of<Jogo>(context, listen: false);
      jogo.equipe_1 = eq1;
      jogo.equipe_2 = eq2;
      jogo.pontosEquipe_1 = 0;
      jogo.pontosEquipe_2 = 0;
      jogo.fimJogo = int.parse(_pontos.text.toString());
      Navigator.of(context).popAndPushNamed('placar');
    } else {
      _alertdialog(context);
    }
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
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
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Time 1"),
                    ),
                    controller: _time1,
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Time 2"),
                    ),
                    controller: _time2,
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Pontos"),
                    ),
                    maxLength: 2,
                    controller: _pontos,
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () => _iniciaJogo(context),
                    // Navigator.of(context).popAndPushNamed('placar'),
                    child: const Text(
                      'Iniciar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
