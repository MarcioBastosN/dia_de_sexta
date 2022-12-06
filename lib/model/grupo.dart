import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  jogadoresTimes(int idTime) {
    List<Grupo> time = [];
    for (var grupo in grupos) {
      if (grupo.idTime == idTime) {
        time.add(grupo);
      }
    }
    return time;
  }

  int qtdjogadoresTime(int idTime) {
    int time = 0;
    for (var grupo in grupos) {
      if (grupo.idTime == idTime) {
        time++;
      }
    }
    return time;
  }

  zerarTimes(BuildContext context) {
    for (var grupo in grupos) {
      DbUtil.delete(TabelasDB.tbGrupos, grupo.id).whenComplete(() {
        // libera o jogador
        Provider.of<Jogador>(context, listen: false).editarJogador(Jogador(
          id: grupo.idJogador,
          nome: Provider.of<Jogador>(context, listen: false)
              .retornaNomejogador(grupo.idJogador!),
          possuiTime: 0,
        ));
        grupos.remove(grupo);
      });
    }
    //recarrega lista times
    Provider.of<Time>(context, listen: false).loadDate();
    notifyListeners();
  }
}
