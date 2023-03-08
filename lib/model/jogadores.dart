import 'package:dia_de_sexta/src/util/tabelas_db.dart';
import 'package:dia_de_sexta/model/grupo.dart';
import 'package:dia_de_sexta/src/util/db_util.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:dia_de_sexta/view/component/text_form_compoment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jogador with ChangeNotifier {
  List<Jogador> jogadores = [];
  List<Jogador> get listaJogadores => [...jogadores];

  int? id;
  String? nome;
  // assume valor de 0 || 1
  int? possuiTime;

  Jogador({this.id, this.nome, this.possuiTime});

// controller
  final nomeJogador = TextEditingController();

// retorna dados do banco;
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.jogadores);
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

// retorna a lista de jogadores disponiveis
  List<Jogador> getListaJogadoresDisponiveis() {
    List<Jogador> listaJogadores = [];
    for (var jogador in jogadores) {
      if (jogador.possuiTime! != 1) {
        listaJogadores.add(jogador);
      }
    }
    return listaJogadores;
  }

// remove jogador
  Future<void> removeJogador(Jogador jogador) async {
    await DbUtil.delete(NomeTabelaDB.jogadores, jogador.id!)
        .whenComplete(() => loadDate());
  }

// editar um jogador
  editarJogador(Jogador jogador) {
    DbUtil.update(NomeTabelaDB.jogadores, jogador.id!, {
      'nome': jogador.nome,
      "possuiTime": jogador.possuiTime!,
    }).whenComplete(() => loadDate());
  }

// alterar o status do jogador para indiponivel
  Future<void> jogadorPossuiTime(List<Jogador> playes) async {
    for (var item in playes) {
      await DbUtil.update(NomeTabelaDB.jogadores, item.id!, {
        "possuiTime": 1,
      }).whenComplete(() => loadDate());
      notifyListeners();
    }
  }

// retornar o id do jogador com base no nome
  retornaIdJogador(String nome) {
    for (var jogador in jogadores) {
      if (jogador.nome! == nome) {
        return jogador.id!;
      }
    }
  }

// retornar o nome do jogador com base no seu ID
  String retornaNomejogador(int id) {
    String nome = "";
    for (var jogador in jogadores) {
      if (jogador.id == id) {
        nome = jogador.nome!;
      }
    }
    return nome;
  }

// adicionar jogador
  Future<void> adicionarJogador(Jogador jogador) async {
    await DbUtil.insert(NomeTabelaDB.jogadores, {
      'nome': jogador.nome.toString(),
      'possuiTime': 0,
    }).whenComplete(() => loadDate());
  }

// liberar todos os jogadores de todos os times
  Future<void> liberarJogadores() async {
    for (var jogador in jogadores) {
      DbUtil.update(NomeTabelaDB.jogadores, jogador.id!, {
        'possuiTime': 0,
      }).whenComplete(() => loadDate());
    }
  }

  // remover o jogador do grupo e habilitar ele para possuir um novo time
  Future<void> liberaJogadorId(int idjogador, BuildContext context) async {
    Provider.of<Grupo>(context, listen: false)
        .removeRegistroJogadorId(idjogador, context);
    await DbUtil.update(NomeTabelaDB.jogadores, idjogador, {
      'possuiTime': 0,
    }).whenComplete(() => loadDate());
  }

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
