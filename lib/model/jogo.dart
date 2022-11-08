import 'package:dia_de_sexta/provider/providerJogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jogo with ChangeNotifier {
  String? equipe_1;
  String? equipe_2;
  late int pontosEquipe_1 = 0;
  late int pontosEquipe_2 = 0;
  late int fimJogo;

  imprimeJogo() {
    print(
        "eq1: $equipe_1, eq2: $equipe_2, p1: $pontosEquipe_1, p2: $pontosEquipe_2, fim: $fimJogo");
  }

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
        FloatingActionButton(
          child: const Text("Novo Jogo"),
          onPressed: () {
            Jogo jogo = Provider.of<Jogo>(context, listen: false);
            Provider.of<ProviderJogo>(context, listen: false).createJogo(jogo);
            print(
                "Lista Jogo Inicio ${Provider.of<ProviderJogo>(context, listen: false).tamanhoListaJogos()}");
            print("dados Jogo ${jogo.imprimeJogo()}");
            Navigator.of(context).popAndPushNamed('/');
          },
        )
      ],
    ),
  );
}
