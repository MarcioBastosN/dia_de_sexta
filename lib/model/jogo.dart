import 'package:flutter/material.dart';

class Jogo with ChangeNotifier {
  List<Jogo> jogos = [];
  get listaJogos => [...jogos];

  int tamanhoListaJogos() {
    return jogos.length;
  }

  createJogo(Jogo jogo) {
    print("imprime Jogo recebido ${jogo.imprimeJogo()}");
    jogos.add(jogo);
    notifyListeners();
    print("Adicionou novo jogo na lista");
    print("Imprime o jogo adicionado ${jogo.imprimeJogo()}");
    print("=========================================");
  }

  String? equipe_1;
  String? equipe_2;
  late int pontosEquipe_1 = 0;
  late int pontosEquipe_2 = 0;
  late int fimJogo;

  iniciaJogo(String eq1, String eq2, int pontosSet) {
    print('Iniciou um Jogo');
    equipe_1 = eq1;
    equipe_2 = eq2;
    pontosEquipe_1 = 0;
    pontosEquipe_2 = 0;
    fimJogo = pontosSet;
    imprimeJogo();
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
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Fim de Jogo"),
        content: const Text('jogo encerado'),
        actions: <Widget>[
          FloatingActionButton(
            child: const Text("Novo Jogo"),
            onPressed: () {
              // print("Iniciou um novo Jogo!");
              // print("+++++++++++++++++++++");
              // print(
              //   "Tamanho lista ${jogo.tamanhoListaJogos()}",
              // );
              // // Provider.of<Jogo>(context, listen: false).createJogo();
              // print("===========LISTA===============");
              // for (Jogo element in jogo.listaJogos) {
              //   print("Lista de jogo ${element.imprimeJogo()}");
              // }
              // print("===========FIM - LISTA===============");
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
