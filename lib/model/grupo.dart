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

  Grupo({this.id, this.idJogador, this.idTime});

  // retorna os dados do banco;
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

// adiciona Jogador(es) ao time
  Future<void> adicionarGrupo(List<Jogador>? jogadores, int idTime) async {
    for (var jogador in jogadores!) {
      await DbUtil.insert(NomeTabelaDB.grupos, {
        'idJogador': jogador.id!,
        'idTime': idTime,
      });
    }
    loadDate();
  }

// retorna os jogadores de um time
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

// remove um grupo
  Future<void> removeGrupo(int? idGrupo) async {
    await DbUtil.delete(NomeTabelaDB.grupos, idGrupo!)
        .whenComplete(() => loadDate());
  }

  zerarTimes(BuildContext context) {
    for (var grupo in grupos) {
      removeGrupo(grupo.id!);
    }
    Provider.of<Jogador>(context, listen: false).liberarJogadores();
    // zerar lista de jogadores time
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

  sorteiaTimes(BuildContext context) {
    var consultaTimesValidos = Provider.of<Time>(context, listen: false)
        .retornaListaTimesIncompletos(context);
    var timeSorteado = Random().nextInt(consultaTimesValidos.length);
    print(
        "times validos: ${consultaTimesValidos.length}, sorteado: $timeSorteado");
    print(
        "Qtd participantes time (${consultaTimesValidos[timeSorteado].nome}): ${consultaTimesValidos[timeSorteado].qtdParticipantes}");

    // int participantesParaTime =
    //     consultaTimesValidos[timeSorteado].qtdParticipantes!;

    // List<Jogador> jogadores = [];

    // if (Provider.of<Jogador>(context, listen: false)
    //         .getListaJogadoresDisponiveis()
    //         .length >=
    //     participantesParaTime) {
    //   for (var i = 0; i < participantesParaTime; i++) {
    //     // sorteia jogador & time
    //     var jogadorSorteado = Random().nextInt(
    //         Provider.of<Jogador>(context, listen: false)
    //             .getListaJogadoresDisponiveis()
    //             .length);
    //     jogadores.add(Provider.of<Jogador>(context, listen: false)
    //         .getListaJogadoresDisponiveis()[jogadorSorteado]);
    //   }

    //   adicionarGrupo(jogadores, consultaTimesValidos[timeSorteado].id!)
    //       .whenComplete(() => Provider.of<Jogador>(context, listen: false)
    //           .jogadorPossuiTime(jogadores))
    //       .whenComplete(() => Provider.of<Time>(context, listen: false)
    //           .incrementaQtdParticipantesTime(consultaTimesValidos[timeSorteado].id!));
    // } else {
    //   for (var i = 0;
    //       i <
    //           Provider.of<Jogador>(context, listen: false)
    //               .getListaJogadoresDisponiveis()
    //               .length;
    //       i++) {
    //     // sorteia jogador & time
    //     var jogadorSorteado = Random().nextInt(
    //         Provider.of<Jogador>(context, listen: false)
    //             .getListaJogadoresDisponiveis()
    //             .length);
    //     jogadores.add(Provider.of<Jogador>(context, listen: false)
    //         .getListaJogadoresDisponiveis()[jogadorSorteado]);
    //   }

    //   adicionarGrupo(jogadores, consultaTimesValidos[timeSorteado].id!)
    //       .whenComplete(() => Provider.of<Jogador>(context, listen: false)
    //           .jogadorPossuiTime(jogadores))
    //       .whenComplete(() => Provider.of<Time>(context, listen: false)
    //           .incrementaQtdParticipantesTime(consultaTimesValidos[timeSorteado].id!));
    // }

    // int verifica = Provider.of<Jogador>(context, listen: false)
    //     .getListaJogadoresDisponiveis()
    //     .length;
    // if (verifica > 0) {
    //   sorteiaTimes(context);
    // }
  }

// remove um jogador do time de acordo com seu id
  removeRegistroJogadorId(int idJogador, BuildContext context) {
    for (var grupo in grupos) {
      if (grupo.idJogador == idJogador) {
        removeGrupo(grupo.id!);
        Provider.of<Time>(context, listen: false)
            .decrementaQtdParticipantesTime(grupo.idTime!);
      }
    }
  }

  //
  List<DropdownMenuItem<int>> listaGruposDisponiveis = [];
  List<Time> listaTimes = [];

// carrega lista de DropdownMenuItem de times
  carregaListaDropdownTimes(BuildContext context) {
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
}//final arquivo
