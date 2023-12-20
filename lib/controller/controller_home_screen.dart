import 'package:get/get.dart';

class ControllerHomeScreen extends GetxController {
  RxInt currentindex = 0.obs;

  updateCurrentIndex({required int newindex}) {
    currentindex.value = newindex;
  }
}
