import 'package:get/get.dart';

class ControllerPlacarComponent extends GetxController {
  RxBool animatedButton = false.obs;

  Future<void> trocaStatusBotao() async {
    animatedButton.value = !animatedButton.value;
    await Future.delayed(const Duration(milliseconds: 1000));
    animatedButton.value = !animatedButton.value;
  }
}
