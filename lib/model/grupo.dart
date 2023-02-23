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
  Future<void> adicionarGrupo(List<Jogador>? jogadores, int idTime) async {
    for (var jogador in jogadores!) {
      await DbUtil.insert(NomeTabelaDB.grupos, {
        'idJogador': jogador.id!,
        'idTime': idTime,
      }).whenComplete(() => loadDate());
    }
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
    // zerar lista de jogadorestime
    Provider.of<Time>(context, listen: false).zerarJogadoresTime();
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

// passos para sortear
// 1 - buscar jogadores disponiveis
// 2 - buscar times com vagas
// 3 - realizar sorteio jogador
  Future<void> sorteiaTimes(BuildContext context) async {
    // List<Jogador> jogadoresDisponiveis =
    //     Provider.of<Jogador>(context, listen: false)
    //         .getListaJogadoresDisponiveis();

    var consultaTimesValidos =
        Provider.of<Time>(context, listen: false).retornaTimesValidos(context);
    var timeSorteado = Random().nextInt(consultaTimesValidos.length);

    if (Provider.of<Jogador>(context, listen: false)
        .getListaJogadoresDisponiveis()
        .isEmpty) {
      print("Jogadores indisponiveis");
      return;
    }

    int participantesParaTime =
        consultaTimesValidos[timeSorteado].qtdParticipantes!;

    List<Jogador> jogadores = [];

    if (Provider.of<Jogador>(context, listen: false)
            .getListaJogadoresDisponiveis()
            .length >=
        participantesParaTime) {
      for (var i = 0; i < participantesParaTime; i++) {
        // sorteia jogador & time
        var jogadorSorteado = Random().nextInt(
            Provider.of<Jogador>(context, listen: false)
                .getListaJogadoresDisponiveis()
                .length);
        jogadores.add(Provider.of<Jogador>(context, listen: false)
            .getListaJogadoresDisponiveis()[jogadorSorteado]);
      }

      await adicionarGrupo(jogadores, consultaTimesValidos[timeSorteado].id!)
          .whenComplete(() => Provider.of<Jogador>(context, listen: false)
              .jogadorPossuiTime(jogadores))
          .whenComplete(() => Provider.of<Time>(context, listen: false)
              .atualizaParticipantes(consultaTimesValidos[timeSorteado].id!));
    } else {
      for (var i = 0;
          i <
              Provider.of<Jogador>(context, listen: false)
                  .getListaJogadoresDisponiveis()
                  .length;
          i++) {
        // sorteia jogador & time
        var jogadorSorteado = Random().nextInt(
            Provider.of<Jogador>(context, listen: false)
                .getListaJogadoresDisponiveis()
                .length);
        jogadores.add(Provider.of<Jogador>(context, listen: false)
            .getListaJogadoresDisponiveis()[jogadorSorteado]);
      }

      await adicionarGrupo(jogadores, consultaTimesValidos[timeSorteado].id!)
          .whenComplete(() => Provider.of<Jogador>(context, listen: false)
              .jogadorPossuiTime(jogadores))
          .whenComplete(() => Provider.of<Time>(context, listen: false)
              .atualizaParticipantes(consultaTimesValidos[timeSorteado].id!));
    }
  }

  bool verificaSorteio(BuildContext context) {
    bool sorteio = false;
    if (Provider.of<Time>(context, listen: false)
        .retornaTimesValidos(context)
        .isNotEmpty) {
      if (Provider.of<Jogador>(context, listen: false)
          .getListaJogadoresDisponiveis()
          .isNotEmpty) {
        sorteio = !sorteio;
      }
    }
    return sorteio;
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

// retorna o numero de jogadores em um time
  int numeroJogadoresTime(int time, BuildContext context) {
    int numeroJogadores = 0;
    for (var grupo in Provider.of<Grupo>(context, listen: false).grupos) {
      if (grupo.idTime! == time) {
        numeroJogadores += 1;
      }
    }
    // print("Jogadores $numeroJogadores, Time $time");
    return numeroJogadores;
  }
}
