
import 'package:comic/global.dart';
import 'package:comic/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitPageController extends GetxController {
  Color bottomNavigationBarColor = Colors.white;

  int currentIndex = 0;

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
  }

  @override
  void onInit() {
    super.onInit();

    init().then((r) {
      /// 读取本地用户数据
      UserData.getInstance.init();

      // UserData.getInstance.clear();
      // prefs.remove('installTime');
      getToken().then((token) {
        // 不等于空的时候说明用户登录了
        if (token != '') {
          ///设置取消校验是否第一次使用
          isFirstTime = true;
        } else {
          ///校验是否是第一次使用
          checkFirstTime(token);
        }
      });
    });
  }

  Future getToken() async {
    var a = await UserData.getInstance.readUserFromStore();
    if (a != null) return a.token;
    return '';
  }
}
