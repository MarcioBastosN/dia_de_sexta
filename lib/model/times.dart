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
}
