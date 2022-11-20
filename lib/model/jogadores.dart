import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:flutter/material.dart';

class Jogador with ChangeNotifier {
  List<Jogador> _Jogadores = [];
  List<Jogador> get listaJogadores => [..._Jogadores];

  int? id;
  String? nome;

  Jogador({
    this.id,
    this.nome,
  });

// retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.jogadores);
    _Jogadores = dataList
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
    return _Jogadores.length;
  }

// remove jogador do banco e da lista
  removeJogador(Jogador jogador) {
    DbUtil.delete(TabelaDB.jogadores, jogador.id).whenComplete(() => {
          _Jogadores.remove(jogador),
          notifyListeners(),
        });
  }

// adiciona jogador na lista e no banco
  adicionarjogador() {
    Jogador jogador = Jogador(
      nome: 'teste',
    );
    _Jogadores.add(jogador);
    DbUtil.insert(TabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
    });
    notifyListeners();
  }
}
