import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControllerIntroScreen extends GetxController {
  RxBool loadSplash = false.obs;
  RxInt currentPage = 0.obs;

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  Future updateLoadSplash({required bool newValue}) async {
    await sharedPrefs.then((SharedPreferences prefs) {
      prefs.setBool("loadSpalsh", newValue);
    });
    loadSplash.value = newValue;
  }

  Future getLoadSplash() async {
    await sharedPrefs.then((SharedPreferences prefs) {
      loadSplash.value = prefs.getBool("loadSpalsh")!;
    });
  }

  updateCurrentPage({required int page}) {
    currentPage.value = page;
  }
}
