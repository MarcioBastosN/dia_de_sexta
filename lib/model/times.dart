import 'package:dia_de_sexta/util/db_util.dart';
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
    times.add(time);
    await DbUtil.insert(TabelaDB.time, {
      'nome': time.nome.toString(),
    });
    notifyListeners();
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
    });
    notifyListeners();
  }

  // remove jogador do banco e da lista
  removeTime(Time time) {
    DbUtil.delete(TabelaDB.time, time.id).whenComplete(() => {
          times.remove(time),
          notifyListeners(),
        });
  }
}
