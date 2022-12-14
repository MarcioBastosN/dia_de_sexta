import 'package:dia_de_sexta/util/db_util.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
import 'package:flutter/material.dart';

import '../app_routes/tabelas_db.dart';

class Time with ChangeNotifier {
  List<Time> times = [];
  List<Time> get listaTimes => [...times];

  int? id;
  String? nome;

  Time({
    this.id,
    this.nome,
  });

  // variaveis de controle
  final nomeTime = TextEditingController();
  // final focusTime = FocusNode();

  // Inicio funcoes

  // retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.time);
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
    await DbUtil.insert(TabelaDB.time, {
      'nome': time.nome.toString(),
    }).whenComplete(() => loadDate());
  }

  int tamanhoListaTimes() {
    return times.length;
  }

  List<String> getNomeTimes() {
    List<String> nomes = [];
    for (var time in times) {
      nomes.add(time.nome.toString());
    }
    return nomes;
  }

  Future<void> editarNomeTime(Time time) async {
    await DbUtil.update(TabelaDB.time, time.id!, {
      'nome': time.nome,
    }).whenComplete(() => loadDate());
  }

  // remove um time
  removeTime(Time time) {
    DbUtil.delete(TabelaDB.time, time.id).whenComplete(() => {loadDate()});
  }

  // chamada para o Dialog, registrar um time
  addTimeLista(BuildContext context) {
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
}
