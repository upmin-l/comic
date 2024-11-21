
import 'package:get/get.dart';

import 'controller.dart';
import 'services.dart';

class MinePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MinePageController());
    Get.lazyPut(() => MinePageServices());
  }
}
