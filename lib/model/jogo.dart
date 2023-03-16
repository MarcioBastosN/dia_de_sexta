import 'package:dia_de_sexta/controller/controller_placar_screen.dart';
import 'package:dia_de_sexta/src/util/routes.dart';
import 'package:dia_de_sexta/src/util/tabelas_db.dart';
import 'package:dia_de_sexta/src/util/db_util.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Jogo with ChangeNotifier {
  List<Jogo> _jogos = [];
  List<Jogo> get listaJogos => [..._jogos];

  //incializado apos salvar no banco
  int? id;
  // relaçao times
  int? equipe_1;
  int? equipe_2;
  // ralacao pontos jogo
  int? pontosEquipe_1;
  int? pontosEquipe_2;
  // Data da partida
  String? data;

  String? tempoJogo;
  // bool? jogoEncerado;
  int? pontosFimJogo;
  // auxiliares

  Jogo({
    this.id,
    this.equipe_1,
    this.equipe_2,
    this.pontosEquipe_1,
    this.pontosEquipe_2,
    this.pontosFimJogo,
    this.data,
    this.tempoJogo,
  });

  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.placar);
    _jogos = dataList
        .map(
          (item) => Jogo(
            id: item['id'],
            equipe_1: int.parse(item['grupo_1'].toString()),
            equipe_2: int.parse(item['grupo_2'].toString()),
            pontosEquipe_1: item['placar1'],
            pontosEquipe_2: item['placar2'],
            data: item['data'],
            tempoJogo: item['tempoJogo'],
          ),
        )
        .toList();
    notifyListeners();
  }

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

  registraJogoDbLista(BuildContext context) {
    DbUtil.insert(NomeTabelaDB.placar, {
      'grupo_1': Provider.of<Jogo>(context, listen: false).equipe_1!,
      'grupo_2': Provider.of<Jogo>(context, listen: false).equipe_2!,
      'placar1': Provider.of<Jogo>(context, listen: false).pontosEquipe_1!,
      'placar2': Provider.of<Jogo>(context, listen: false).pontosEquipe_2!,
      'data': Provider.of<Jogo>(context, listen: false).data!,
      'tempoJogo': Provider.of<Jogo>(context, listen: false).tempoJogo!,
    }).whenComplete(() => loadDate());
  }

  removeJogo(Jogo jogo) {
    DbUtil.delete(NomeTabelaDB.placar, jogo.id)
        .whenComplete(() => {loadDate()});
  }

  fecharPartida(BuildContext context) {
    registraJogoDbLista(context);
    Get.offNamed(AppRoutes.home);
  }

  void criarjgo(Jogo jogo) {
    final registroData = DateTime.now();
    final dataCorrigida = DateFormat('d/M/y').format(registroData);
    equipe_1 = jogo.equipe_1;
    equipe_2 = jogo.equipe_2;
    pontosEquipe_1 = 0;
    pontosEquipe_2 = 0;
    pontosFimJogo = jogo.pontosFimJogo;
    data = dataCorrigida;
    notifyListeners();
  }

  void vaiUm() {
    pontosFimJogo = pontosFimJogo! + 1;
    notifyListeners();
  }

  bool verificaEmpateUltimoPonto() {
    int valor = (pontosFimJogo! - 1);
    bool compara = false;
    if ((pontosEquipe_1 == valor) && (pontosEquipe_2 == valor)) {
      compara = true;
    }
    return compara;
  }

  void adicionaPontosEqp1(
      BuildContext context, ControllerPlacarScreen controllerPlacar) {
    pontosEquipe_1 = pontosEquipe_1! + 1;
    if (pontosEquipe_1! <= (pontosFimJogo! - 1)) {
      if ((pontosEquipe_1 == (pontosFimJogo! - 1)) &&
          (verificaEmpateUltimoPonto() == false)) {
        _alertUltimoPonto(context);
      }
      notifyListeners();
    } else {
      notifyListeners();
      _alertpontosFimJogo(context, controllerPlacar);
    }
    if (verificaEmpateUltimoPonto()) {
      _alertSegueJogo(context);
    }
  }

  void adicionaPontosEqp2(
      BuildContext context, ControllerPlacarScreen controllerPlacar) {
    pontosEquipe_2 = pontosEquipe_2! + 1;
    if (pontosEquipe_2! <= (pontosFimJogo! - 1)) {
      if ((pontosEquipe_2 == (pontosFimJogo! - 1)) &&
          (verificaEmpateUltimoPonto() == false)) {
        _alertUltimoPonto(context);
      }
      notifyListeners();
    } else {
      notifyListeners();
      _alertpontosFimJogo(context, controllerPlacar);
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

  void _alertpontosFimJogo(
      BuildContext context, ControllerPlacarScreen controllerPlacar) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Fim de Jogo",
        mensagem: Text(
          "reiniciar jogo",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        listaCompomentes: [
          OutlinedButton(
            child: Text(
              'Reiniciar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outlineVariant,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              registraJogoDbLista(context);
              // inicia novo jogo
              Provider.of<Jogo>(context, listen: false).criarjgo(
                Jogo(
                  equipe_1: Provider.of<Jogo>(context, listen: false).equipe_1,
                  equipe_2: Provider.of<Jogo>(context, listen: false).equipe_2,
                  pontosFimJogo:
                      Provider.of<Jogo>(context, listen: false).pontosFimJogo,
                ),
              );
              // fecha o tempo do jogo
              controllerPlacar.cancelaContadorTempo();
              // reinicia o tempo
              controllerPlacar.disparaContadorTempo();
            },
          ),
          ElevatedButton(
            child: Text(
              "Salvar e sair",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              registraJogoDbLista(context);
              controllerPlacar.cancelaContadorTempo();
              Get.offNamed(AppRoutes.home);
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
        mensagem: Text(
          "Como deseja continuar?",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        listaCompomentes: [
          ElevatedButton(
            child: Text(
                "Vai a Dois\n (${(Provider.of<Jogo>(context, listen: false).pontosFimJogo! + 1)} pontos)"),
            onPressed: () {
              Provider.of<Jogo>(context, listen: false).vaiUm();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text(
                "fechar em ${Provider.of<Jogo>(context, listen: false).pontosFimJogo}"),
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
      builder: (context) => DialogComponent(
        titulo: "Ultimo Ponto!",
        mensagem: Text(
          "Ultimo ponto para fechar o jogo",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }
}
