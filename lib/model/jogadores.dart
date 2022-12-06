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

  int tamanhoListaJogadores() {
    return jogadores.length;
  }

  List<String> getNomejogadores() {
    List<String> nomes = [];
    for (var jogador in jogadores) {
      nomes.add(jogador.nome.toString());
    }
    return nomes;
  }

  List<String> getNomejogadoresDisponiveis() {
    List<String> nomes = [];
    for (var jogador in jogadores) {
      if (jogador.possuiTime != 1) {
        nomes.add(jogador.nome.toString());
      }
    }
    return nomes;
  }

  int getIdjogador(String nome) {
    return 0;
  }

// remove jogador do banco e da lista
  removeJogador(Jogador jogador) {
    DbUtil.delete(TabelaDB.jogadores, jogador.id).whenComplete(() => {
          jogadores.remove(jogador),
          notifyListeners(),
        });
  }

// adiciona jogador na lista e no banco
  Future<void> adicionarJogador(Jogador jogador) async {
    jogadores.add(jogador);
    await DbUtil.insert(TabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
      'possuiTime': 0,
    });
    notifyListeners();
  }

  editarJogador(Jogador jogador) {
    DbUtil.update(TabelaDB.jogadores, jogador.id!, {
      'nome': jogador.nome,
      "possuiTime": jogador.possuiTime,
    });
    notifyListeners();
  }

  int? retornaIdJogador(String nome) {
    for (var jogador in jogadores) {
      if (jogador.nome! == nome) {
        return jogador.id!;
      }
    }
  }

  String retornaNomejogador(int id) {
    String nome = "";
    for (var jogador in jogadores) {
      if (jogador.id == id) {
        nome = jogador.nome!;
      }
    }
    return nome;
  }
}
