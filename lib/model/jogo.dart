import 'dart:math';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:dia_de_sexta/view/compoment/dialogComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jogo with ChangeNotifier {
  List<Jogo> _jogos = [];
  List<Jogo> get listaJogos => [..._jogos];

  Future<void> loadDate() async {
    final dataList = await DbUtil.getData('placar');
    _jogos = dataList
        .map(
          (item) => Jogo(
            id: item['id'],
            equipe_1: item['grupo_1'],
            equipe_2: item['grupo_2'],
            pontosEquipe_1: item['placar1'],
            pontosEquipe_2: item['placar2'],
          ),
        )
        .toList();
    notifyListeners();
  }

  int? id;
  String? equipe_1;
  String? equipe_2;
  int? pontosEquipe_1;
  int? pontosEquipe_2;
  int fimJogo;
  bool? jogoEncerado;

  Jogo({
    this.id,
    this.equipe_1,
    this.equipe_2,
    this.pontosEquipe_1,
    this.pontosEquipe_2,
    this.fimJogo = 10,
    this.jogoEncerado,
  });

  int tamanhoListaJogos() {
    return _jogos.length;
  }

  createJogo(Jogo jogo) {
    _jogos.add(jogo);
    DbUtil.insert('placar', {
      'id': Random().nextDouble().toInt(),
      'grupo_1': jogo.equipe_1.toString(),
      'grupo_2': jogo.equipe_2.toString(),
      'placar1': int.parse(jogo.pontosEquipe_1.toString()),
      'placar2': int.parse(jogo.pontosEquipe_2.toString()),
    });
    notifyListeners();
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

  bool verificaEmpateUltimoPonto() {
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
      if ((pontosEquipe_1 == (fimJogo - 1)) &&
          (verificaEmpateUltimoPonto() == false)) {
        _alertUltimoPonto(context);
      }
      notifyListeners();
    } else {
      notifyListeners();
      _alertFimJogo(context);
    }
    if (verificaEmpateUltimoPonto()) {
      _alertSegueJogo(context);
    }
  }

  void adicionaPontosEqp2(BuildContext context) {
    pontosEquipe_2 = pontosEquipe_2! + 1;
    if (pontosEquipe_2! <= (fimJogo - 1)) {
      if ((pontosEquipe_2 == (fimJogo - 1)) &&
          (verificaEmpateUltimoPonto() == false)) {
        _alertUltimoPonto(context);
      }
      notifyListeners();
    } else {
      notifyListeners();
      _alertFimJogo(context);
    }
    if (verificaEmpateUltimoPonto()) {
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
        titulo: "Empate ultimo ponto!",
        mensagem: "Como deseja continuar?",
        listaCompomentes: [
          ElevatedButton(
            child: Text(
                "Vai a Dois\n (${(Provider.of<Jogo>(context, listen: false).fimJogo + 1)} pontos)"),
            onPressed: () {
              Provider.of<Jogo>(context, listen: false).vaiUm();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
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

  void _alertUltimoPonto(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => const DialogComponent(
        titulo: "Ultimo Ponto!",
        mensagem: "ultimo ponto para fechar o jogo",
      ),
    );
  }
}
