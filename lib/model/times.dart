import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/src/util/db_util.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:dia_de_sexta/view/component/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../src/util/tabelas_db.dart';

class Time with ChangeNotifier {
  List<Time> times = [];
  List<Time> get listaTimes => [...times];

  int? id;
  String? nome;
  int? qtdParticipantes;

  Time({this.id, this.nome, this.qtdParticipantes});

  // variaveis de controle
  final nomeTime = TextEditingController();
  final focusTime = FocusNode();

  // retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.time);
    times = dataList
        .map(
          (item) => Time(
            id: item['id'],
            nome: item['nome'],
            qtdParticipantes: item['qtdParticipantes'],
          ),
        )
        .toList();
    notifyListeners();
  }

  // adiciona Time
  Future<void> adicionarTime(Time time) async {
    await DbUtil.insert(NomeTabelaDB.time, {
      'nome': time.nome.toString(),
      'qtdParticipantes': time.qtdParticipantes!,
    }).whenComplete(() => loadDate());
  }

  // Retorna os times que não estao completos.
  List<Time> retornaListaTimesIncompletos(BuildContext context) {
    loadDate();
    final limiteJogadores = Provider.of<Definicoes>(context, listen: false)
        .retornaLimiteJogadoresParaUmGrupo();
    List<Time> timesValidos = [];
    for (var time in times) {
      if (time.qtdParticipantes! < limiteJogadores) {
        timesValidos.add(time);
      }
    }
    return timesValidos;
  }

// retorna o tamanho da lista bde times
  int tamanhoListaTimes() {
    return times.length;
  }

// Editar o nome do time
  Future<void> editarNomeTime(Time time) async {
    await DbUtil.update(NomeTabelaDB.time, time.id!, {
      'nome': time.nome,
    }).whenComplete(() => loadDate());
  }

  // retorna a quantidade de participantes do time
  int qtdParticipantesTime(int idTime) {
    loadDate();
    int valor = 0;
    for (var time in times) {
      if (time.id! == idTime) {
        valor = time.qtdParticipantes!;
      }
    }
    return valor;
  }

  //incrementa a quantidade de participantes de um Time
  incrementaQtdParticipantesTime(int idTime, int qtdParticipantes) {
    loadDate();
    for (var time in times) {
      if (time.id == idTime) {
        time.qtdParticipantes =
            (qtdParticipantesTime(idTime) + qtdParticipantes);
        editarQtdJogadores(time);
        notifyListeners();
      }
    }
  }

  // decrementa a quantidade de participantes de um Time
  decrementaQtdParticipantesTime(int idTime) {
    loadDate();
    for (var element in listaTimes) {
      if (element.id == idTime) {
        element.qtdParticipantes = (qtdParticipantesTime(idTime) - 1);
        editarQtdJogadores(element);
      }
    }
  }

// zera a quantidade de jogadores de todos os time
  zerarJogadoresTime() {
    for (var element in listaTimes) {
      element.qtdParticipantes = 0;
      editarQtdJogadores(element);
      notifyListeners();
    }
  }

  // atualiza a quantidade de participantes de um time
  Future<void> editarQtdJogadores(Time time) async {
    await DbUtil.update(NomeTabelaDB.time, time.id!, {
      'qtdParticipantes': time.qtdParticipantes,
    }).whenComplete(() => loadDate());
    notifyListeners();
  }

  // remove um time e seus participantes
  Future<void> removeTimeEParticipantes(Time time, BuildContext context) async {
    List<Grupo> jogadoresTime =
        Provider.of<Grupo>(context, listen: false).listaGrupos;
    await DbUtil.delete(NomeTabelaDB.time, time.id)
        .whenComplete(() => loadDate());
    for (var jogador in jogadoresTime) {
      if (jogador.idTime! == time.id) {
        await DbUtil.update(NomeTabelaDB.jogadores, jogador.idJogador!, {
          "possuiTime": 0,
        }).whenComplete(
            () => Provider.of<Jogador>(context, listen: false).loadDate());
      }
    }
  }

  // retorna o nome do Time
  String retornaNomeTime(int idTimeSelecionado) {
    String nomeTime = "";
    for (var element in listaTimes) {
      if (element.id == idTimeSelecionado) {
        nomeTime = element.nome!;
      }
    }
    return nomeTime;
  }

  // chamada para o Dialog, registrar um time
  addTimeLista() {
    nomeTime.value = const TextEditingValue(text: "");
    Get.dialog(
      DialogComponent(
        titulo: 'Registrar time',
        listaCompomentes: [
          TextFormCompoment(
            controller: nomeTime,
            label: "Nome do time",
            inputType: TextInputType.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("salvar"),
                  onPressed: () {
                    final time = nomeTime.text.toString().trim();
                    if (time.isNotEmpty) {
                      adicionarTime(Time(nome: time, qtdParticipantes: 0))
                          .whenComplete(
                        () => nomeTime.value = const TextEditingValue(text: ""),
                      );
                    }
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // chamada para o Dialog, Editar nome time
  editaNomeTime(Time time) {
    nomeTime.text = time.nome!;
    focusTime.requestFocus();
    Get.dialog(
      DialogComponent(
        titulo: 'Qual novo nome do seu Time?',
        listaCompomentes: [
          TextFormCompoment(
            controller: nomeTime,
            focus: focusTime,
            label: "Nome",
            inputType: TextInputType.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("salvar"),
                  onPressed: () {
                    final player = nomeTime.text.toString().trim();
                    if (player.isNotEmpty) {
                      editarNomeTime(Time(id: time.id!, nome: player));
                    }
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
