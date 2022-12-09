import 'package:dia_de_sexta/app_routes/routes.dart';
import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Jogo with ChangeNotifier {
  List<Jogo> _jogos = [];
  List<Jogo> get listaJogos => [..._jogos];

  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.placar);
    _jogos = dataList
        .map(
          (item) => Jogo(
            id: item['id'],
            equipe_1: item['grupo_1'],
            equipe_2: item['grupo_2'],
            pontosEquipe_1: item['placar1'],
            pontosEquipe_2: item['placar2'],
            data: item['data'],
            tempoJogo: item['tempoJogo'],
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
  String? tempoJogo;
  String? data;
  bool? jogoEncerado;
  // auxiliares
  DateTime? _inicioPartida;

  Jogo({
    this.id,
    this.equipe_1,
    this.equipe_2,
    this.pontosEquipe_1,
    this.pontosEquipe_2,
    this.fimJogo = 10,
    this.jogoEncerado,
    this.data,
    this.tempoJogo,
  });

  int tamanhoListaJogos() {
    return _jogos.length;
  }

  String retonaTempo(String valor) {
    String tempo = valor;
    if (int.parse(valor) > 60) {
      tempo = (int.parse(valor) / 60).toStringAsPrecision(3);
    }
    return tempo;
  }

  tempoJogado() {
    // guardar os minutos
    double tempo = 0;
    if (_jogos.isNotEmpty) {
      for (var item in _jogos) {
        tempo += int.parse(item.tempoJogo!.toString());
      }
    }
    if (tempo > 60) {
      tempo = (tempo / 60);
    }
    return tempo.toStringAsPrecision(3);
  }

  registraJogoDbLista(BuildContext context) {
    Jogo jogo = Jogo(
      equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
      equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
      pontosEquipe_1: Provider.of<Jogo>(context, listen: false).pontosEquipe_1,
      pontosEquipe_2: Provider.of<Jogo>(context, listen: false).pontosEquipe_2,
      fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
      data: Provider.of<Jogo>(context, listen: false).data,
    );
    _jogos.add(jogo);
    final fimPartida = DateTime.now();
    final DateTime test = _inicioPartida!;
    var tempoJogo = fimPartida.difference(test);
    jogo.tempoJogo = tempoJogo.inSeconds.toString();

    DbUtil.insert(TabelaDB.placar, {
      'grupo_1': jogo.equipe_1.toString(),
      'grupo_2': jogo.equipe_2.toString(),
      'placar1': int.parse(jogo.pontosEquipe_1.toString()),
      'placar2': int.parse(jogo.pontosEquipe_2.toString()),
      'data': jogo.data.toString(),
      'tempoJogo': jogo.tempoJogo.toString(),
    });
    notifyListeners();
  }

  removeJogo(Jogo jogo) {
    DbUtil.delete(TabelaDB.placar, jogo.id).whenComplete(() => {
          _jogos.remove(jogo),
          notifyListeners(),
        });
  }

  fecharPartida(BuildContext context) {
    registraJogoDbLista(context);
    Navigator.of(context).popAndPushNamed(AppRoutes.home);
  }

  void criarjgo(Jogo jogo) {
    final registroData = DateTime.now();
    final dataCorrigida = DateFormat('d/M/y').format(registroData);
    equipe_1 = jogo.equipe_1;
    equipe_2 = jogo.equipe_2;
    pontosEquipe_1 = 0;
    pontosEquipe_2 = 0;
    fimJogo = jogo.fimJogo;
    data = dataCorrigida;
    _inicioPartida = registroData;
    notifyListeners();
  }

  void vaiUm() {
    fimJogo++;
    notifyListeners();
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
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Fim de Jogo",
        mensagem: const Text("reiniciar mantem as equipes"),
        listaCompomentes: [
          OutlinedButton(
            child: const Text(
              'Reiniciar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // registra o jogo
              registraJogoDbLista(context);
              // inicia novo jogo
              Provider.of<Jogo>(context, listen: false).criarjgo(
                Jogo(
                  equipe_1:
                      Provider.of<Jogo>(context, listen: false).equipe_1 ??
                          "equipe_1",
                  equipe_2:
                      Provider.of<Jogo>(context, listen: false).equipe_2 ??
                          "equipe_2",
                  fimJogo: Provider.of<Jogo>(context, listen: false).fimJogo,
                ),
              );
              notifyListeners();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Salvar e sair",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              registraJogoDbLista(context);
              Navigator.of(context).popAndPushNamed(AppRoutes.home);
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
        mensagem: const Text("Como deseja continuar?"),
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
        mensagem: Text("Ultimo ponto para fechar o jogo"),
      ),
    );
  }
}
