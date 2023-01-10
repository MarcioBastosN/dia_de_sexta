import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes/tabelas_db.dart';

class Time with ChangeNotifier {
  List<Time> times = [];
  List<Time> get listaTimes => [...times];

  int? id;
  String? nome;

  Time({this.id, this.nome});

  // variaveis de controle
  final nomeTime = TextEditingController();
  final focusTime = FocusNode();

  // Inicio funcoes

  // retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.time);
    times = dataList
        .map(
          (item) => Time(
            id: item['id'],
            nome: item['nome'],
          ),
        )
        .toList();
    notifyListeners();
  }

  // adiciona Time na lista e no banco
  Future<void> adicionarTime(Time time) async {
    await DbUtil.insert(NomeTabelaDB.time, {
      'nome': time.nome.toString(),
    }).whenComplete(() => loadDate());
  }

// retorna o tamanho da lista bde times
  int tamanhoListaTimes() {
    return times.length;
  }

// Retorna a lista de Nomes de times
  List<String> getNomeTimes() {
    List<String> nomes = [];
    for (var time in times) {
      nomes.add(time.nome.toString());
    }
    return nomes;
  }

// Editar nome do time
  Future<void> editarNomeTime(Time time) async {
    await DbUtil.update(NomeTabelaDB.time, time.id!, {
      'nome': time.nome,
    }).whenComplete(() => loadDate());
  }

  // remove um time e seus participantes
  removeTime(Time time, BuildContext context) {
    DbUtil.delete(NomeTabelaDB.time, time.id).whenComplete(() => {loadDate()});
    List<Grupo> jogadoresTime =
        Provider.of<Grupo>(context, listen: false).listaGrupos;
    for (var jogador in jogadoresTime) {
      if (jogador.idTime! == time.id) {
        DbUtil.update(NomeTabelaDB.jogadores, jogador.idJogador!, {
          "possuiTime": 0,
        });
      }
    }
    Provider.of<Jogador>(context, listen: false).loadDate();
  }

  // chamada para o Dialog, registrar um time
  addTimeLista(BuildContext context) {
    nomeTime.value = const TextEditingValue(text: "");
    showDialog(
      context: context,
      builder: (context) => DialogComponent(
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
                      adicionarTime(Time(nome: time)).whenComplete(
                        () => nomeTime.value = const TextEditingValue(text: ""),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Editar nome time
  editaNomeTime(BuildContext context, Time time) {
    nomeTime.text = time.nome!;
    focusTime.requestFocus();
    showDialog(
      context: context,
      builder: (context) => DialogComponent(
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // retornar lista de dropdown Jogadores disponiveis
  List<DropdownMenuItem<int>> listaJogadoresDisponiveis = [];
  List<Jogador> listaJogadores = [];

  carregaJogadoresDisponiveis(BuildContext context) {
    listaJogadoresDisponiveis.clear();
    listaJogadores =
        Provider.of<Jogador>(context, listen: false).listaJogadores;
    for (var element in listaJogadores) {
      if (element.possuiTime == 0) {
        listaJogadoresDisponiveis.add(
          DropdownMenuItem(
            value: element.id,
            child: Text(element.nome!),
          ),
        );
        notifyListeners();
      }
    }
  }

  String retornaNomeTime(int idTimeSelecionado) {
    String nomeTime = "";
    for (var element in listaTimes) {
      if (element.id == idTimeSelecionado) {
        nomeTime = element.nome!;
      }
    }
    return nomeTime;
  }
}
