
import 'package:get/get.dart';

import 'controller.dart';
import 'services.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
    // Get.lazyPut(() => Comic18Services());
  }
}
