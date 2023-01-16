import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:dia_de_sexta/util/db_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Definicoes with ChangeNotifier {
  int? id;
  int? numeroJogadores;

  List<Definicoes> def = [];
  List<Definicoes> get listaDef => [...def];

  Definicoes({
    this.id,
    this.numeroJogadores,
  });

  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.definicoesJogo);
    def = dataList
        .map(
          (item) => Definicoes(
            id: item['id'],
            numeroJogadores: item['numeroJogadores'],
          ),
        )
        .toList();
    notifyListeners();
  }

  int tamanhoListaDefinicoes() {
    return def.length;
  }

// adiciona definicao.
  Future<void> adicionarDefinicao(Definicoes definicao) async {
    await DbUtil.insert(NomeTabelaDB.definicoesJogo, {
      'numeroJogadores': definicao.numeroJogadores!,
    }).whenComplete(() => loadDate());
  }

  //
  int retornaLimiteJogadores() {
    int valor = 0;
    for (var dados in def) {
      valor = dados.numeroJogadores!;
    }
    return valor;
  }

  // TODO - utilizar esta funcao
  // edita o numero de Jogadores disponiveis - atualiza a quantidade dos times
  atualizaDefinicoes(Definicoes definicoes, BuildContext context) {
    DbUtil.update(NomeTabelaDB.definicoesJogo, definicoes.id!, {
      'numeroJogadores': definicoes.numeroJogadores,
    }).whenComplete(() => loadDate().whenComplete(
          () {
            // atualiza os grupos
            var times = Provider.of<Time>(context, listen: false).times;

            for (var item in times) {
              item.editarQtdJogadores(definicoes.numeroJogadores!);
            }
          },
        ));
  }
}
