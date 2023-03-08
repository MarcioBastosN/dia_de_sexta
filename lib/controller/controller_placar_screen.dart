import 'dart:async';

import 'package:get/get.dart';

class ControllerPlacarScreen extends GetxController {
  RxBool trocaLadoJogo = false.obs;
  RxInt tempoJogo = 0.obs;
  RxString tempoDaPartida = "".obs;
  RxInt time = 0.obs;
  // controle timer
  Timer? timeActive;

  inverteLadoJogo() {
    trocaLadoJogo.value = !trocaLadoJogo.value;
  }

  // necesario passar o tempo.obs do time
  formataTempo({required int tempo}) {
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
    tempoDaPartida.value = "$nim m $sec s";
  }

  disparaContadorTempo() {
    timeActive = Timer.periodic(const Duration(seconds: 1), (timer) {
      time.value += 1;
      formataTempo(tempo: time.value);
    });
  }

  cancelaContadorTempo() {
    timeActive!.cancel();
    time.value = 0;
  }
}
