import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:get/get.dart';



class AppGlobalServices extends GetConnect {
  static AppGlobalServices get to => Get.find();


  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = globalBaseUrl;
  }

  Future<CustomerModel> getCustomer(String type) async{
    String url = '/irregular/getCustomer';

    final res = await get(url, query: {"type":type});
    if (res.hasError) return Future.error(Exception(res.statusCode));

    return CustomerModel.fromJson(res.body['data']);
  }
}
