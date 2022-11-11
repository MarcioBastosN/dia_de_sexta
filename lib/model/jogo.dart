import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jogo with ChangeNotifier {
  final List<Jogo> _jogos = [];
  List<Jogo> get listaJogos => [..._jogos];

  String? equipe_1;
  String? equipe_2;
  int? pontosEquipe_1;
  int? pontosEquipe_2;
  int fimJogo;

  Jogo({
    this.equipe_1,
    this.equipe_2,
    this.pontosEquipe_1,
    this.pontosEquipe_2,
    this.fimJogo = 10,
  });

  int tamanhoListaJogos() {
    return _jogos.length;
  }

  createJogo(Jogo jogo) {
    print("imprime Jogo recebido ");
    imprimeJogo();
    _jogos.add(jogo);
    notifyListeners();
    print("Adicionou novo jogo na lista");
    print("=========================================");
  }

  criarjgo(Jogo jogo) {
    equipe_1 = jogo.equipe_1;
    equipe_2 = jogo.equipe_2;
    pontosEquipe_1 = jogo.pontosEquipe_1;
    pontosEquipe_2 = jogo.pontosEquipe_2;
    fimJogo = jogo.fimJogo;
    notifyListeners();
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
    print("eq_1: $equipe_1, pontos_1: $pontosEquipe_1, " +
        "eq_2: $equipe_2, pontos_2: $pontosEquipe_2,  fim: $fimJogo");
  }

  bool verificaplacar() {
    int valor = (fimJogo - 1);
    bool compara = false;
    if ((pontosEquipe_1 == valor) && (pontosEquipe_2 == valor)) {
      compara = true;
    }
    print("func compara: $compara");
    return compara;
  }

  adicionaPontosEqp1(BuildContext context) {
    pontosEquipe_1 = pontosEquipe_1! + 1;
    if (pontosEquipe_1! <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertdialog(context);
    }
    if (verificaplacar()) {
      _alertSegueJogo(context);
    }
  }

  adicionaPontosEqp2(BuildContext context) {
    pontosEquipe_2 = pontosEquipe_2! + 1;
    if (pontosEquipe_2! <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertdialog(context);
    }
    if (verificaplacar()) {
      _alertSegueJogo(context);
    }
  }

  removePontosEquipe_1() {
    if (pontosEquipe_1! > 0) {
      pontosEquipe_1 = pontosEquipe_1! - 1;
    }
    notifyListeners();
  }

  removePontosEquipe_2() {
    if (pontosEquipe_2! > 0) {
      pontosEquipe_2 = pontosEquipe_2! - 1;
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
              backgroundColor: Colors.white30,
              foregroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Jogo Rapido",
            ),
            onPressed: () {
              Navigator.of(context).pop();
              createJogo(
                Jogo(
                  equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
                  equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
                  pontosEquipe_1:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_1,
                  pontosEquipe_2:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_2,
                  fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
                ),
              );
              Jogo(
                equipe_1: "equipe_1",
                equipe_2: "equipe_2",
                fimJogo: 10,
              );
              Navigator.of(context).popAndPushNamed('placar');
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
              print("registra ultimo jogo");
              createJogo(
                Jogo(
                  equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
                  equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
                  pontosEquipe_1:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_1,
                  pontosEquipe_2:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_2,
                  fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
                ),
              );
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
        ],
      ),
    );
  }

  void _alertSegueJogo(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Empate ultimo pomto!",
        mensagem: "Como deseja continuar?",
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
            child: const Text("continuar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
