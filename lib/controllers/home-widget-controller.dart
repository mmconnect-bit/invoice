import 'package:get/get_state_manager/get_state_manager.dart';

class HomeControllerWidget extends GetxController {
  int tabNo = 1;
  void onTab(int index) {
    tabNo = index;
    update();
  }
}
