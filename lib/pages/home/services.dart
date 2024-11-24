import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:get/get.dart';



class Comic18Services extends GetConnect {
  static Comic18Services get to => Get.find();


  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = globalBaseUrl;
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] =
      'Bearer ${UserData.getInstance.userData?.t}';
      return request;
    });
  }

  Future<ComicResponse> getComicList(GetComicParameter parameter) async {
    String url = '/comic/hcomic';
    // 使用扩展运算符构建查询参数 Map
    final queryParams = {
      ...parameter.toMap(), // 通过扩展运算符将 GetComicParameter 转换为 Map
    };

    final res = await get(url, query: queryParams);
    if (res.hasError) return Future.error(Exception(res.statusCode));

    return ComicResponse.fromJson(res.body);
  }
}
