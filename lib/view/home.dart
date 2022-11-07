import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final _time1 = TextEditingController();
  final _time2 = TextEditingController();
  final _pontos = TextEditingController();

  void _iniciaJogo(context) {
    if (_time1.text.toString().trim().isNotEmpty &&
        _time2.text.toString().trim().isNotEmpty) {
      Navigator.of(context).popAndPushNamed('placar');
    }
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
