import 'package:flutter/material.dart';

class Jogo with ChangeNotifier{ 

  String? equipe_1;
  String? equipe_2;
  late int pontosEquipe_1 = 0;
  late int pontosEquipe_2 = 0;
  late int fimJogo = 10;

  adicionaPontosEqp1()
  {
    pontosEquipe_1 ++;
    notifyListeners();
  }
  
  adicionaPontosEqp2()
  {
    pontosEquipe_1 ++;
    notifyListeners();
  }
  
  removePontosEquipe_1()
  {
    if(pontosEquipe_1 > 0){
      pontosEquipe_1 --;
    }
    notifyListeners();
  }

  removePontosEquipe_2()
  {
    if(pontosEquipe_2 > 0){
      pontosEquipe_2 --;
    }
    notifyListeners();
  }

}