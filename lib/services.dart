import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:get/get.dart';

class AppGlobalServices extends GetConnect {
  static AppGlobalServices get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = globalBaseUrl;
    if (UserData.getInstance.userData?.token != null) {
      httpClient.addRequestModifier<dynamic>((request) {
        request.headers['Authorization'] =
            'Bearer ${UserData.getInstance.userData?.token}';
        return request;
      });
    }
  }

  Future<CustomerModel> getCustomer(String type) async {
    String url = '/irregular/getCustomer';

    final res = await get(url, query: {"type": type});
    if (res.hasError) return Future.error(Exception(res.statusCode));

    return CustomerModel.fromJson(res.body['data']);
  }

  ///获取用户漫画阅读历史
  Future<ComicChapterListItem> getComicStorage([String? id]) async {
    String url = '/user/hcomicStorage';
    final res = await get(url, query: {'id': id});
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return ComicChapterListItem.fromJson(res.body['data']);
  }

  /// 保存用户收藏漫画
  Future setComicStorage(SetComicStorageModel comicStorageModel) async {
    String url = '/user/setcomicStorage';

    // 使用扩展运算符构建查询参数 Map
    final queryParams = {
      ...comicStorageModel.toMap(), // 通过扩展运算符将 GetComicParameter 转换为 Map
    };
    final res = await post(url, queryParams);
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return ComicResponse.fromJson(res.body);
  }

  ///校验token是否过期
  Future getValidateToken(TokenModel tokenModel) async {
    String url = '/user/validatetoken';

    final res = await post(url, tokenModel.toMap());
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return res.body['data'];
  }
}
