import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:flutter/material.dart';

class Jogador with ChangeNotifier {
  List<Jogador> jogadores = [];
  List<Jogador> get listaJogadores => [...jogadores];

  int? id;
  String? nome;

  Jogador({
    this.id,
    this.nome,
  });

// retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.jogadores);
    jogadores = dataList
        .map(
          (item) => Jogador(
            id: item['id'],
            nome: item['nome'],
          ),
        )
        .toList();
    notifyListeners();
  }

  int tamanhoListaJogadores() {
    return jogadores.length;
  }

// remove jogador do banco e da lista
  removeJogador(Jogador jogador) {
    DbUtil.delete(TabelaDB.jogadores, jogador.id).whenComplete(() => {
          jogadores.remove(jogador),
          notifyListeners(),
        });
  }

// adiciona jogador na lista e no banco
  adicionarJogador(Jogador jogador) {
    jogadores.add(jogador);
    DbUtil.insert(TabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
    });
    notifyListeners();
  }

  editarJogador(Jogador jogador) {
    DbUtil.update(TabelaDB.jogadores, jogador.id!, {
      'nome': jogador.nome,
    });
    notifyListeners();
  }
}
