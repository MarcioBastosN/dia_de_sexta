import 'dart:math';

import 'package:dia_de_sexta/model/definicoes.dart';
import 'package:dia_de_sexta/model/jogadores.dart';
import 'package:dia_de_sexta/model/times.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/util/tabelas_db.dart';
import '../src/util/db_util.dart';

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

  // o sorteio so inicia se tiver jogadores disponiveis
  sorteiaTimes(
      {required BuildContext context,
      required List<Time> timesValidos,
      required List<Jogador> listaJogadoresDisponiveis}) {
    List<Time> consultaTimesValidos = timesValidos;

    if (consultaTimesValidos.isEmpty) {
      return;
    }

    int timeSorteado = Random().nextInt(consultaTimesValidos.length);
    int participantesFaltando = Provider.of<Definicoes>(context, listen: false)
            .retornaLimiteJogadoresParaUmGrupo() -
        consultaTimesValidos[timeSorteado].qtdParticipantes!;

    //armazena a lista de jogadores disponiveis
    List<Jogador> jogadoresDisponiveis = listaJogadoresDisponiveis;

    List<Jogador> listaJogadoresParaAdicionar = [];

    // verifica a quantidade de jogadores
    if (jogadoresDisponiveis.length > participantesFaltando) {
      for (int i = 0; i < participantesFaltando; i++) {
        // sorteia jogador
        var jogadorSorteado = Random().nextInt(jogadoresDisponiveis.length);
        // adiciona o jogador sorteado na lista de jogadores para adicionar
        listaJogadoresParaAdicionar.add(jogadoresDisponiveis[jogadorSorteado]);
        // remove o jogador sorteado da lista de jogadores disponiveis
        jogadoresDisponiveis.remove(jogadoresDisponiveis[jogadorSorteado]);
      }

      adicionarGrupo(listaJogadoresParaAdicionar,
              consultaTimesValidos[timeSorteado].id!)
          .whenComplete(() => Provider.of<Jogador>(context, listen: false)
              .jogadorPossuiTime(listaJogadoresParaAdicionar));
      Provider.of<Time>(context, listen: false).incrementaQtdParticipantesTime(
          consultaTimesValidos[timeSorteado].id!, participantesFaltando);
    } else {
      participantesFaltando = jogadoresDisponiveis.length;

      for (int i = 0; i < participantesFaltando; i++) {
        // sorteia jogador
        var jogadorSorteado = Random().nextInt(jogadoresDisponiveis.length);
        // adiciona o jogador sorteado na lista de jogadores para adicionar
        listaJogadoresParaAdicionar.add(jogadoresDisponiveis[jogadorSorteado]);
        // remove o jogador sorteado da lista de jogadores disponiveis
        jogadoresDisponiveis.remove(jogadoresDisponiveis[jogadorSorteado]);
      }

      adicionarGrupo(listaJogadoresParaAdicionar,
              consultaTimesValidos[timeSorteado].id!)
          .whenComplete(() => Provider.of<Jogador>(context, listen: false)
              .jogadorPossuiTime(listaJogadoresParaAdicionar));
      Provider.of<Time>(context, listen: false).incrementaQtdParticipantesTime(
          consultaTimesValidos[timeSorteado].id!, participantesFaltando);
    }

    consultaTimesValidos.remove(consultaTimesValidos[timeSorteado]);
    if (jogadoresDisponiveis.isNotEmpty && consultaTimesValidos.isNotEmpty) {
      sorteiaTimes(
          context: context,
          timesValidos: consultaTimesValidos,
          listaJogadoresDisponiveis: jogadoresDisponiveis);
    } else {
      // print("sorteio_ sorteio finalizado");
    }
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
} //final arquivo
