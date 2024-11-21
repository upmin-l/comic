import 'package:comic/global.dart';
import 'package:get/get.dart';



class MinePageServices extends GetConnect {
  static MinePageServices get to => Get.find();


  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = globalBaseUrl;
  }


}
