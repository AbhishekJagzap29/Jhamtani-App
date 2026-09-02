import 'package:get/get.dart';

class IntroScreenController extends GetxController {
  int select = 0;

  changeIndex(int index) {
    select = index;
    update();
  }
}
