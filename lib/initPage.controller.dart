import 'package:comic/global.dart';
import 'package:comic/pages/index.dart';
import 'package:comic/public.models.dart';
import 'package:comic/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InitPageController extends GetxController {
  Color bottomNavigationBarColor = Colors.white;

  final appGlobalServices = Get.find<AppGlobalServices>();
  int currentIndex = 0;
  /// app 版本
  String version ='';
  bool isAppUpdate = false;
  late CustomerModel appMsg;

  late SharedPreferences prefs;

  /// 校验是否第一次安装打开app 用来做一天内免费使用功能
  bool isFirstTime = false;

  late List<Widget> pages = [
    const ComicPage(),
    const HomePage(),
    const BookshelfPage(),
    const MinePage(),
  ];

  void updateCurrentIndex(index) {
    currentIndex = index;
    update(['InitPage']);
  }

  /// 校验是否第一次运行
  Future<void> checkFirstTime(token) async {
    if (token != '') return;

    DateTime? installTime =
        DateTime.tryParse(prefs.getString('installTime') ?? '');
    if (installTime == null) {
      prefs.setString('installTime', DateTime.now().toIso8601String());
    } else {
      Duration difference = DateTime.now().difference(installTime);
      print('$installTime ----$difference----${difference.inSeconds}');
      print(difference.inSeconds < 60);
      // difference.inDays<1
      if (difference.inSeconds < 60) {
        isFirstTime = true;
      } else {
        isFirstTime = false;
      }
    }
  }

  ///初始化设置
  Future init() async {
    prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    /// 请求app 是否需要更新
    appMsg = await appGlobalServices.getCustomer('app',version);
    if(appMsg.data.version!=version){
      isAppUpdate = true;
    }else{
      isAppUpdate = false;
    }
    update(['InitPage']);
  }

  Future<void> onOpenUrl() async {
    Uri uri = Uri.parse(appMsg.tap_url);
    if (!await canLaunchUrl(uri)) throw Exception('错误');

    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw Exception('无法唤起 QQ，请检查 QQ 是否安装');
    }
  }


  @override
  void onInit() {
    super.onInit();

    init().then((r) async{
      /// 读取本地用户数据
      await UserData.getInstance.init();

      // UserData.getInstance.clear();
      // prefs.remove('installTime');
      getToken().then((token) {
        // 不等于空的时候说明用户登录了
        if (token != '') {
          ///设置取消校验是否第一次使用
          isFirstTime = true;

          TokenModel tokenModel = TokenModel(
            user: UserData.getInstance.userData?.user ?? '',
            id: UserData.getInstance.userData?.id ?? '',
            t: UserData.getInstance.userData?.t ?? '',
          );
          ///更新token
          appGlobalServices.getValidateToken(tokenModel).then((value){
              UserData.getInstance.setUserData = value;
              appGlobalServices.httpClient.addRequestModifier<dynamic>((request) {
                request.headers['Authorization'] =
                'Bearer ${UserData.getInstance.userData?.t}';
                return request;
              });
          });
        } else {
          ///校验是否是第一次使用
          checkFirstTime(token);
        }
      });
    });
  }

  Future getToken() async {
    var a =  UserData.getInstance.userData;
    if (a != null) return a.t;
    return '';
  }
}
