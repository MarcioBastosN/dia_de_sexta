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
  bool jogoEncerado;

  Jogo({
    this.equipe_1,
    this.equipe_2,
    this.pontosEquipe_1,
    this.pontosEquipe_2,
    this.fimJogo = 10,
    this.jogoEncerado = false,
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

  void criarjgo(Jogo jogo) {
    equipe_1 = jogo.equipe_1;
    equipe_2 = jogo.equipe_2;
    pontosEquipe_1 = jogo.pontosEquipe_1;
    pontosEquipe_2 = jogo.pontosEquipe_2;
    fimJogo = jogo.fimJogo;
    notifyListeners();
  }

  void vaiUm() {
    fimJogo++;
    notifyListeners();
  }

  void imprimeJogo() {
    print(
        "eq_1: $equipe_1, pontos_1: $pontosEquipe_1, eq_2: $equipe_2, pontos_2: $pontosEquipe_2,  fim: $fimJogo");
  }

  void desativaJogo() {
    jogoEncerado = true;
  }

  bool verificaPlacar() {
    int valor = (fimJogo - 1);
    bool compara = false;
    if ((pontosEquipe_1 == valor) && (pontosEquipe_2 == valor)) {
      compara = true;
    }
    return compara;
  }

  void adicionaPontosEqp1(BuildContext context) {
    pontosEquipe_1 = pontosEquipe_1! + 1;
    if (pontosEquipe_1! <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertFimJogo(context);
    }
    if (verificaPlacar()) {
      _alertSegueJogo(context);
    }
  }

  void adicionaPontosEqp2(BuildContext context) {
    pontosEquipe_2 = pontosEquipe_2! + 1;
    if (pontosEquipe_2! <= (fimJogo - 1)) {
      notifyListeners();
    } else {
      notifyListeners();
      _alertFimJogo(context);
    }
    if (verificaPlacar()) {
      _alertSegueJogo(context);
    }
  }

  void removePontosEquipe_1() {
    if (pontosEquipe_1! > 0) {
      pontosEquipe_1 = pontosEquipe_1! - 1;
    }
    notifyListeners();
  }

  void removePontosEquipe_2() {
    if (pontosEquipe_2! > 0) {
      pontosEquipe_2 = pontosEquipe_2! - 1;
    }
    notifyListeners();
  }

  void _alertFimJogo(BuildContext context) {
    // Provider.of<Jogo>(context, listen: false).desativaJogo();
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
              // registra o jogo
              createJogo(
                Jogo(
                  equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
                  equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
                  pontosEquipe_1:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_1,
                  pontosEquipe_2:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_2,
                  fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
                  jogoEncerado: true,
                ),
              );
              // inicia novo jogo
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
              createJogo(
                Jogo(
                  equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
                  equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
                  pontosEquipe_1:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_1,
                  pontosEquipe_2:
                      Provider.of<Jogo>(context, listen: false).pontosEquipe_2,
                  fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
                  jogoEncerado: true,
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
            child: Text(
                "Vai a Dois\n (${(Provider.of<Jogo>(context, listen: false).fimJogo + 1)} pontos)"),
            onPressed: () {
              Provider.of<Jogo>(context, listen: false).vaiUm();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
                "fechar em ${Provider.of<Jogo>(context, listen: false).fimJogo}"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
