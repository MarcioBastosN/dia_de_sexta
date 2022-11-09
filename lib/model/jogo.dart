import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jogo with ChangeNotifier {
  List<Jogo> _jogos = [];
  get listaJogos => [..._jogos];

  String? equipe_1;
  String? equipe_2;
  late int pontosEquipe_1 = 0;
  late int pontosEquipe_2 = 0;
  late int fimJogo;

  int tamanhoListaJogos() {
    return _jogos.length;
  }

  createJogo(Jogo jogo) {
    print("imprime Jogo recebido ${jogo.imprimeJogo()}");
    _jogos.add(jogo);
    notifyListeners();
    print("Adicionou novo jogo na lista");
    print("Imprime o jogo adicionado ${jogo.imprimeJogo()}");
    print("=========================================");
  }

  iniciaJogo(String eq1, String eq2, int pontosSet) {
    print('Iniciou um Jogo');
    equipe_1 = eq1;
    equipe_2 = eq2;
    pontosEquipe_1 = 0;
    pontosEquipe_2 = 0;
    fimJogo = pontosSet;
    imprimeJogo();
  }

  vaiUm() {
    fimJogo++;
    notifyListeners();
  }

  vaiDois() {
    fimJogo += 2;
    notifyListeners();
  }

  imprimeJogo() {
    print(
        "eq_1: $equipe_1, pontos_1: $pontosEquipe_1, eq_2: $equipe_2, pontos_2: $pontosEquipe_2,  fim: $fimJogo");
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

  void _alertdialog(BuildContext context) {
    print("finalizou a partida");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Fim de Jogo",
        mensagem: "jogo encerado",
        listaCompomentes: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Vai a Um"),
            onPressed: () {
              Provider.of<Jogo>(context, listen: false).vaiUm();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Vai a Dois"),
            onPressed: () {
              Provider.of<Jogo>(context, listen: false).vaiDois();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Novo Jogo"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
