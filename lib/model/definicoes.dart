import 'package:dia_de_sexta/src/util/tabelas_db.dart';
import 'package:dia_de_sexta/src/util/db_util.dart';
import 'package:dia_de_sexta/view/component/dialog_component.dart';
import 'package:dia_de_sexta/view/component/text_form_compoment.dart';
import 'package:flutter/material.dart';

class Definicoes with ChangeNotifier {
  int? id;
  int? numeroJogadores;

  List<Definicoes> def = [];
  List<Definicoes> get listaDef => [...def];

  Definicoes({
    this.id,
    this.numeroJogadores,
  });

  // controller
  final qtdJogadores = TextEditingController();

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

  Definicoes retornaDefinicaoEditar() {
    return def[0];
  }

// adiciona definicao.
  Future<void> adicionarDefinicao(Definicoes definicao) async {
    await DbUtil.insert(NomeTabelaDB.definicoesJogo, {
      'numeroJogadores': definicao.numeroJogadores!,
    }).whenComplete(() => loadDate());
  }

  //retorna o numero de jogadores q um grupo pode possuir
  int retornaLimiteJogadoresParaUmGrupo() {
    int valor = 0;
    for (var dados in def) {
      valor = dados.numeroJogadores!;
    }
    return valor;
  }

  atualizaDefinicoes(Definicoes definicoes, BuildContext context) {
    DbUtil.update(NomeTabelaDB.definicoesJogo, definicoes.id!, {
      'numeroJogadores': definicoes.numeroJogadores,
    }).whenComplete(() => loadDate());
  }

  trocaNumeroParticipantes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogComponent(
        titulo: "Participantes por Time",
        listaCompomentes: [
          TextFormCompoment(
            controller: qtdJogadores,
            label: "Nº Jogadores",
            inputType: TextInputType.phone,
            maxLength: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                var atualizar = retornaDefinicaoEditar();
                atualizar.numeroJogadores = (int.parse(qtdJogadores.text));
                atualizaDefinicoes(atualizar, context);
                Navigator.of(context).pop();
              },
              child: const Text("Salvar"),
            ),
          ),
        ],
      ),
    );
  }
}
