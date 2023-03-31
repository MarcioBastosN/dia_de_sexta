import 'package:dia_de_sexta/model/jogo.dart';
import 'package:get/get.dart';

class ControllerJogo extends GetxController {
  Rx<Jogo> jogo = Jogo().obs;
  RxBool verificaEmpate = false.obs;

  incrementaPlacarEqp_1() {
    jogo.update((obj) {
      obj?.pontosEquipe_1 = (obj.pontosEquipe_1! + 1);
    });
    verificaEmpateUltimoPonto();
  }

  incrementaPlacarEqp_2() {
    jogo.update((obj) {
      obj?.pontosEquipe_2 = (obj.pontosEquipe_2! + 1);
    });
    verificaEmpateUltimoPonto();
  }

  decrementaPlacarEqp_1() {
    if (jogo.value.pontosEquipe_1! > 1) {
      jogo.update((obj) {
        obj?.pontosEquipe_1 = (obj.pontosEquipe_1! - 1);
      });
    }
  }

  decrementaPlacarEqp_2() {
    jogo.update((obj) {
      obj?.pontosEquipe_2 = (obj.pontosEquipe_2! - 1);
    });
  }

  verificaEmpateUltimoPonto() {
    int valor = (jogo.value.pontosFimJogo! - 1);
    if ((jogo.value.pontosEquipe_1 == valor) &&
        (jogo.value.pontosEquipe_2 == valor)) {
      verificaEmpate.value = true;
    }
  }
}
