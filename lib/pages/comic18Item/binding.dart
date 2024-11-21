import 'package:get/get.dart';
import './controller.dart';

class ComicItem18PageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Comic18ItemPageController());
  }
}
