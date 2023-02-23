import 'dart:async';

import 'package:get/get.dart';

class DefPartida extends GetxController {
  bool trocaLadoJogo = false;
  int tempoJogo = 0;
  String? tempoDaPartida;
  Timer? timeActive;
  int time = 0;

  bool animatedButton = false;

  Future<void> animaButton() async {
    animatedButton = !animatedButton;
    update();
    await Future.delayed(const Duration(milliseconds: 1000));
    animatedButton = !animatedButton;
    update();
  }

  disparaTempo() {
    timeActive = Timer.periodic(const Duration(seconds: 1), (timer) {
      time += 1;
      update();
    });
  }

  cancelaContador() {
    timeActive!.cancel();
    time = 0;
    update();
  }

  String formataTempo(int tempo) {
    int nim = 0;
    int sec = 0;
    if (tempo > 60) {
      do {
        tempo = tempo - 60;
        if (tempo > 1) {
          nim++;
        }
      } while (tempo > 60);
    }
    sec = tempo;
    tempoDaPartida = "$nim m $sec s";
    update();
    return "$nim m $sec s";
  }
}
