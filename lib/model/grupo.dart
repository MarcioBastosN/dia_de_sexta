import 'dart:math';

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
  // TODO - alterar map para while ou do while || foreach
  Future<void> loadDate() async {
    final dataList = await DbUtil.getData(NomeTabelaDB.grupos);
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
    await DbUtil.insert(NomeTabelaDB.grupos, {
      'idJogador': grupo.idJogador!,
      'idTime': grupo.idTime!,
    }).whenComplete(() => loadDate());
  }

// retorna os jogadores de um grupo
  jogadoresTimes(int idTime, BuildContext context) {
    List<Jogador> time = [];
    List<Jogador> jogadores =
        Provider.of<Jogador>(context, listen: false).listaJogadores;
    for (var grupo in grupos) {
      if (grupo.idTime == idTime) {
        for (var jogador in jogadores) {
          if (jogador.id == grupo.idJogador) {
            time.add(jogador);
          }
        }
      }
    }
    return time;
  }

// retorna a quantidade de jogdores de um grupo
  int qtdjogadoresTime(int idTime) {
    int time = 0;
    for (var grupo in grupos) {
      if (grupo.idTime == idTime) {
        time++;
      }
    }
    return time;
  }

  Future<void> removeGrupo(int? idGrupo) async {
    await DbUtil.delete(NomeTabelaDB.grupos, idGrupo!)
        .whenComplete(() => loadDate());
  }

  zerarTimes(BuildContext context) {
    for (var grupo in grupos) {
      removeGrupo(grupo.id!);
    }
    Provider.of<Jogador>(context, listen: false).liberarjogadores();
    Provider.of<Time>(context, listen: false).loadDate();
  }

  bool verificaParticipantesDisponiveis(BuildContext context) {
    var teste = false;
    for (var element
        in Provider.of<Jogador>(context, listen: false).listaJogadores) {
      if (element.possuiTime == 0) {
        teste = true;
      }
    }
    return teste;
  }

// para realizar o sorteio a quantidade de participantes disponiveis deve ser maior que a de grupos
  sorteiaTimes(BuildContext context) {
    int jogadores = Provider.of<Jogador>(context, listen: false)
        .getListaJogadoresDisponiveis()
        .length;
    int times = Provider.of<Time>(context, listen: false).listaTimes.length;
    int numeroJogadores = 0;
    if (jogadores >= times) {
      numeroJogadores = (jogadores / times).floor();
      var listaJogadores = Provider.of<Jogador>(context, listen: false)
          .getListaJogadoresDisponiveis();
      for (var time in Provider.of<Time>(context, listen: false).listaTimes) {
        for (var i = 0; i < numeroJogadores; i++) {
          var teste = Random().nextInt(listaJogadores.length);
          do {
            teste = Random().nextInt(listaJogadores.length);
          } while (listaJogadores[teste].possuiTime == 1);

          adicionarGrupo(
              Grupo(idJogador: listaJogadores[teste].id!, idTime: time.id));
          Provider.of<Jogador>(context, listen: false)
              .jogadorPossuiTime(listaJogadores[teste].id!);
          listaJogadores.removeAt(teste);
        }
      }
    } else {
      return;
    }
  }

// remove um jogador do grupo de acordo com seu id
  removeRegistroJogadorId(int idJogador) {
    for (var grupo in grupos) {
      if (grupo.idJogador == idJogador) {
        removeGrupo(grupo.id!);
      }
    }
  }

  //
  List<DropdownMenuItem<int>> listaGruposDisponiveis = [];
  List<Time> listaTimes = [];

  carregaTimesDisponiveis(BuildContext context) {
    listaGruposDisponiveis.clear();
    listaTimes = Provider.of<Time>(context, listen: false).listaTimes;
    for (var element in listaTimes) {
      listaGruposDisponiveis.add(
        DropdownMenuItem(
          value: element.id,
          child: Text(element.nome!),
        ),
      );
    }
  }
}
