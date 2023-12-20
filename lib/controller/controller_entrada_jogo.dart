import 'package:get/get.dart';

class ControllerEntradaJogo extends GetxController {
  RxInt idTime_1 = 0.obs;
  RxInt idTime_2 = 0.obs;

  updateTime_1({required int newValue}) {
    idTime_1.value = newValue;
  }

  updateTime_2({required int newValue}) {
    idTime_2.value = newValue;
  }
}
