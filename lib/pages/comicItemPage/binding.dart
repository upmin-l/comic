import 'package:get/get.dart';
import './controller.dart';

class ComicItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ComicItemPageController());
  }
}
