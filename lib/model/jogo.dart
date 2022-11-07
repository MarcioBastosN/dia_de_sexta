import 'package:flutter/material.dart';

class Jogo with ChangeNotifier {
  String? equipe_1;
  String? equipe_2;
  late int pontosEquipe_1 = 0;
  late int pontosEquipe_2 = 0;
  late int fimJogo;

  adicionaPontosEqp1(BuildContext context) {
    pontosEquipe_1++;
    if (pontosEquipe_1 <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertdialog(context);
    }
  }

  adicionaPontosEqp2(BuildContext context) {
    pontosEquipe_2++;
    if (pontosEquipe_2 <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertdialog(context);
    }
  }

  removePontosEquipe_1() {
    if (pontosEquipe_1 > 0) {
      pontosEquipe_1--;
    }
    notifyListeners();
  }

  removePontosEquipe_2() {
    if (pontosEquipe_2 > 0) {
      pontosEquipe_2--;
    }
    notifyListeners();
  }
}

void _alertdialog(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Fim de Jogo"),
      content: const Text('jogo encerado'),
      actions: <Widget>[
        // FloatingActionButton(
        //   child: const Text("fechar"),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        FloatingActionButton(
          child: const Text("Novo Jogo"),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        )
      ],
    ),
  );
}
