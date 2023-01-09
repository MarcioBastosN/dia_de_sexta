import 'dart:math';

import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
        // percorre a lista de jogadores para buscar o id do jogador
        for (var jogador in jogadores) {
          if (jogador.id == grupo.idJogador) {
            // adiciona o jogador a lista
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
    //recarrega lista times
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

// para realizar o sorteio a quantidade de participantes
//deve ser maior que a de grupos
// buscar lista de jogadores validos
  sorteiaTimes(BuildContext context) {
    // verificar a quantidade de participantes DISPONIVEIS
    int jogadores = Provider.of<Jogador>(context, listen: false)
        .getListaJogadoresDisponiveis()
        .length;
    // verificar a quantidade de grupos
    int times = Provider.of<Time>(context, listen: false).listaTimes.length;
    // dividir a quantidade de participantes por grupos (jogadores validos)
    int numeroJogadores = 0;
    if (jogadores >= times) {
      numeroJogadores = (jogadores / times).floor();
      // verifica a quantide de jogadores por time
      var listaJogadores = Provider.of<Jogador>(context, listen: false)
          .getListaJogadoresDisponiveis();
      for (var time in Provider.of<Time>(context, listen: false).listaTimes) {
        for (var i = 0; i < numeroJogadores; i++) {
          // buscar os jogadores habilitados
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
    // carrega a lista de times
    listaTimes = Provider.of<Time>(context, listen: false).listaTimes;
    for (var element in listaTimes) {
      listaGruposDisponiveis.add(
        DropdownMenuItem(
          value: element.id,
          child: Text(element.nome!),
        ),
      );
      // notifyListeners();
    }
  }
}
