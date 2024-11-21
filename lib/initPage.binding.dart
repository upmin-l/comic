
import 'package:comic/initPage.controller.dart';
import 'package:comic/pages/home/services.dart';
import 'package:comic/pages/index.dart';
import 'package:comic/services.dart';
import 'package:get/get.dart';



class InitPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitPageController());
    Get.lazyPut(() => AppGlobalServices());
    Get.lazyPut(() => ComicServices());
    Get.lazyPut(() => Comic18Services());
  }
}


class ComicReaderPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ComicReaderPageController());
  }
}

class SearchPageBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SearchPageController());
  }
}

class LoginPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageController());
    Get.lazyPut(() => LoginServices());
  }
}