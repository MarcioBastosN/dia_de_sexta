import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:flutter/material.dart';

class Jogador with ChangeNotifier {
  List<Jogador> jogadores = [];
  List<Jogador> get listaJogadores => [...jogadores];

  int? id;
  String? nome;
  // equilave ao booleano que nao possui representaçao no sqflite
  // assume valor de 0 || 1
  int? possuiTime;

  Jogador({
    this.id,
    this.nome,
    this.possuiTime,
  });

// retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(TabelaDB.jogadores);
    jogadores = dataList
        .map(
          (item) => Jogador(
            id: item['id'],
            nome: item['nome'],
            possuiTime: item['possuiTime'],
          ),
        )
        .toList();
    notifyListeners();
  }

// retorna a quantidade de jogadores na lista
  int tamanhoListaJogadores() {
    return jogadores.length;
  }

// retorna o nome dos jogadores disponiveis
  List<String> getNomejogadoresDisponiveis() {
    List<String> nomes = [];
    for (var jogador in jogadores) {
      if (jogador.possuiTime != 1) {
        nomes.add(jogador.nome.toString());
      }
    }
    return nomes;
  }

// remove jogador do banco e da lista
  removeJogador(Jogador jogador) {
    DbUtil.delete(TabelaDB.jogadores, jogador.id)
        .whenComplete(() => {loadDate()});
  }

// adiciona jogador na lista e no banco
  Future<void> adicionarJogador(Jogador jogador) async {
    await DbUtil.insert(TabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
      'possuiTime': 0,
    }).whenComplete(() => loadDate());
  }

// edita um jogador
  editarJogador(Jogador jogador) {
    DbUtil.update(TabelaDB.jogadores, jogador.id!, {
      'nome': jogador.nome,
      "possuiTime": jogador.possuiTime,
    });
    notifyListeners();
  }

// retorna o id do jogador
  retornaIdJogador(String nome) {
    for (var jogador in jogadores) {
      if (jogador.nome! == nome) {
        return jogador.id!;
      }
    }
  }

// retorna o nome do jogador
  String retornaNomejogador(int id) {
    String nome = "";
    for (var jogador in jogadores) {
      if (jogador.id == id) {
        nome = jogador.nome!;
      }
    }
    return nome;
  }

// libera todos os jogadores q possuem time
  Future<void> liberarjogadores() async {
    for (var jogador in jogadores) {
      DbUtil.update(TabelasDB.tbJogadores, jogador.id!, {
        'possuiTime': 0,
      }).whenComplete(() => loadDate());
    }
  }
}
