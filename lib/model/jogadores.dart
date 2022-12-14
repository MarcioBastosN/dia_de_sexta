import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:dia_de_sexta/view/compoment/dialog_component.dart';
import 'package:dia_de_sexta/view/compoment/text_form_compoment.dart';
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

// controller
  final nomeJogador = TextEditingController();

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
  List<Jogador> getListaJogadoresDisponiveis() {
    List<Jogador> listaJogadores = [];
    for (var jogador in jogadores) {
      if (jogador.possuiTime != 1) {
        listaJogadores.add(jogador);
      }
    }
    return listaJogadores;
  }

// remove jogador do banco e da lista
  removeJogador(Jogador jogador) {
    DbUtil.delete(TabelaDB.jogadores, jogador.id)
        .whenComplete(() => {loadDate()});
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

// adiciona jogador na lista e no banco
  Future<void> adicionarJogador(Jogador jogador) async {
    await DbUtil.insert(TabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
      'possuiTime': 0,
    }).whenComplete(() => loadDate());
  }

// libera todos os jogadores de todos os times
  Future<void> liberarjogadores() async {
    for (var jogador in jogadores) {
      DbUtil.update(TabelasDB.tbJogadores, jogador.id!, {
        'possuiTime': 0,
      }).whenComplete(() => loadDate());
    }
  }

// chamada para o Dialog, registar um jogador
  addJogadorLista(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogComponent(
        titulo: 'Registrar jogador',
        listaCompomentes: [
          TextFormCompoment(
            controller: nomeJogador,
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
                    final player = nomeJogador.text.toString().trim();
                    if (player.isNotEmpty) {
                      adicionarJogador(Jogador(nome: player)).whenComplete(
                        () => nomeJogador.value =
                            const TextEditingValue(text: ""),
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
