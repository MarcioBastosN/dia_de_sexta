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
    // print("sorteio_ ==========================");
    List<Time> consultaTimesValidos = timesValidos;

    if (consultaTimesValidos.isEmpty) {
      // print("sorteio_ nao ha times disponiveis");
      return;
    }

    int timeSorteado = Random().nextInt(consultaTimesValidos.length);
    int participantesFaltando = Provider.of<Definicoes>(context, listen: false)
            .retornaLimiteJogadoresParaUmGrupo() -
        consultaTimesValidos[timeSorteado].qtdParticipantes!;

    //armazena a lista de jogadores disponiveis
    List<Jogador> jogadoresDisponiveis = listaJogadoresDisponiveis;

    List<Jogador> listaJogadoresParaAdicionar = [];
    // print(
    //     "sorteio_ times validos: ${consultaTimesValidos.length}, sorteado Time id: ${consultaTimesValidos[timeSorteado].id}");
    // print(
    //     "sorteio_ Nome e ID time: (${consultaTimesValidos[timeSorteado].nome}, ${consultaTimesValidos[timeSorteado].id}) - Qtd participantes: ${consultaTimesValidos[timeSorteado].qtdParticipantes}");
    // print("sorteio_ completar participantes: $participantesFaltando");

    // print(
    //     "sorteio_ iniciando jogadores disponiveis-- ${jogadoresDisponiveis.length}");

    // print(
    //     "sorteio_ id time sorteado ${consultaTimesValidos[timeSorteado].id!}");

    // verifica a quantidade de jogadores
    if (jogadoresDisponiveis.length > participantesFaltando) {
      // print("sorteio_ forma de sorteio - completo");
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
      // print("sorteio_ forma de sorteio - parcial");
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

    // print("sorteio_ fechando -- ${jogadoresDisponiveis.length}");
    consultaTimesValidos.remove(consultaTimesValidos[timeSorteado]);
    if (jogadoresDisponiveis.isNotEmpty && consultaTimesValidos.isNotEmpty) {
      // print(
      //     "sorteio_ times e jogadores disponiveis: t-${consultaTimesValidos.length} ; j-${jogadoresDisponiveis.length}");
      // print("sorteio_ -------------------------------");
      // Provider.of<Time>(context, listen: false)
      //     .retornaListaTimesIncompletos(context);
      // print("sorteio_ -------------------------------");
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
