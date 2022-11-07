import 'package:dia_de_sexta/model/jogo.dart';
import 'package:flutter/material.dart';

class ProviderJogo with ChangeNotifier {
  List<Jogo> jogos = [];
  get listaJogos => [...jogos];

  int tamanhoListaJogos() {
    return jogos.length;
  }

  createJogo(Jogo jogo) {
    jogos.add(jogo);
    notifyListeners();
  }
}
