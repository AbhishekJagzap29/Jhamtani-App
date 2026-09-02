import 'package:get/get.dart';

class ImageCaptureScreenController extends GetxController {
  bool imageSaver = false;

  loader(bool value) {
    imageSaver = value;
    update();
  }
}
