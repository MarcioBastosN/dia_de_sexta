import 'package:flutter/material.dart';

import '../app_routes/tabelas_db.dart';
import '../util/db_util.dart';

class Grupo with ChangeNotifier {
  List<Grupo> grupos = [];
  List<Grupo> get listaGrupos => [...grupos];

  int? id;
  int? idJogador;
  int? idTime;

  Grupo({
    this.id,
    this.idJogador,
    this.idTime,
  });

  // retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.grupos);
    grupos = dataList
        .map(
          (item) => Grupo(
            id: item['id'],
            idJogador: item['idJogador'],
            idTime: item['idTime'],
          ),
        )
        .toList();
    notifyListeners();
  }

// adiciona grupo
  Future<void> adicionarGrupo(Grupo grupo) async {
    grupos.add(grupo);
    await DbUtil.insert(TabelaDB.grupos, {
      'idJogador': grupo.idJogador!,
      'idTime': grupo.idTime!,
    });
    notifyListeners();
  }
}
