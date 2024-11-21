import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:get/get.dart';

class LoginServices extends GetConnect {
  static LoginServices get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = globalBaseUrl;
  }

  /// 登录 接口
  Future<ResponseModel> signIn(
    String user,
    String paw,
  ) async {
    String url = '/user/login';
    final res = await post(url, {
      "user": user,
      "paw": paw,
    });

    if (res.hasError) return Future.error(Exception(res.statusCode));
    return ResponseModel.fromJson(res.body);
    // return ResponseModel.fromJson(res.body);
  }

  Future<String> getUser(String user) async {
    String url = '/user/getuser';

    final res = await get(url, query: {'user': user});
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return res.body;
  }

  /// 注册

  Future<ResponseModel> register(
    String user,
    String paw,
    String belong,
  ) async {
    String url = '/user/register';
    final res = await post(url, {"user": user, "paw": paw, 'belong': belong});
    print(res.body);
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return ResponseModel.fromJson(res.body);
  }
}
