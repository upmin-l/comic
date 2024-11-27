import 'dart:async';

import 'package:bruno/bruno.dart';
import 'package:comic/global.dart';
import 'package:comic/initPage.controller.dart';
import 'package:comic/pages/index.dart';
import 'package:comic/public.models.dart';
import 'package:comic/services.dart';
import 'package:comic/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePageController extends GetxController {
  MinePageController();
  final appGlobalServices = Get.find<AppGlobalServices>();
  final initPageController = Get.find<InitPageController>();
  final bookshelfPageController = Get.find<BookshelfPageController>();
  late List<MineList> mineList = [
    MineList(name: '设置', icon: Icons.settings_suggest, key: 0),
    MineList(name: '账号信息', icon: Icons.manage_accounts, key: 1),
  ];

  late UserModel userData =
      UserData.getInstance.userData ?? UserModel.fromJson({});
  //客服qq
  CustomerModel customer = CustomerModel.fromJson({});

  LoginServices loginServices = Get.put(LoginServices());

  // banner 图， 埋点，后期有广告可以打进来
  CustomerModel bannerRes = CustomerModel.fromJson({});

  /// 拦截登录界面，表示用户是否已经登录了
  bool isLogin = false;

  Future getCustomer() async {
    appGlobalServices
        .getCustomer('support', initPageController.version)
        .then((value) {
      customer = value;
      initData();
    });
  }

  Future getBanner() async {
    appGlobalServices
        .getCustomer('banner', initPageController.version)
        .then((value) {
      bannerRes = value;
      initData();
    });
  }

  Future<void> onOpenUrl(String url) async {
    Uri uri = Uri.parse('https://qm.qq.com/cgi-bin/qm/qr?k=$url');
    if (!await canLaunchUrl(uri)) throw Exception('错误');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('无法唤起 QQ，请检查 QQ 是否安装');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    if (UserData.getInstance.userData != null) isLogin = true;

    getBanner();
    getCustomer();

    //用来远程通知当前页面刷新 目前在登录页面有使用
    loginStreamController.stream.listen((event) {
      if (UserData.getInstance.userData != null) {
        userData = UserData.getInstance.userData!;
        isLogin = true;
        initData();
      }
    });
  }

  initData() {
    update(["minePage"]);
  }

  Future refreshUser() async {
    TokenModel tokenModel = TokenModel(
      user: userData.user ,
      id: userData.id ,
      t: userData.t ,
    );
    userData = UserModel.fromJson({});
    UserData.getInstance.clear();

    appGlobalServices.getValidateToken(tokenModel).then((value) {
      print('getValidateToken${value.type}');
      UserData.getInstance.setUserData = value;
      userData = UserData.getInstance.userData!;
      initData();
    });
  }

  Future logout(context) async {
    BrunoDialog.showConfirmDialog(
      context,
      title: '确定退出登录？',
      msg: '退出登录后您的数据将清除，需要重新登录！',
      confirm: '确定',
      tip: '',
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        userData = UserModel.fromJson({});
        UserData.getInstance.clear();
        isLogin = false;
        BrnToast.show("退出成功！", context);
        bookshelfPageController.updateUserData();

        ///当退出登录后进行锁定，不能跳到阅读页面
        initPageController.isFirstTime = false;
        Navigator.pop(context);
        Navigator.pop(context);
        initData();
      },
    );
  }

  /// 出来设置 账号信息等跳转
  Future<List<ListData>> handleFun(int id) async {
    if (id == 1) {
      return [
        ListData(name: '用户ID', msg: userData.id, id: 35),
        ListData(name: '邀请码', msg: '', id: 32),
        ListData(name: '修改登录密码', shouEndIcon: true, id: 65),
      ];
    }
    return [];
  }

  /// 处理设置 账号信息等回调
  handleFunListClick(BuildContext context, int id) {
    switch (id) {
      case 1:
        logout(context);
        break;
      case 11:
        BrunoDialog.showConfirmDialog(
          context,
          title: '确定清除',
          msg: '是否确定清理缓存？',
          confirm: '确定',
          tip: '',
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: () {
            DefaultCacheManager().emptyCache();
            BrnToast.show("清理成功！", context);
            Navigator.pop(context);
          },
        );
        break;
      case 23: // 检测更新
        break;
      default:
    }
  }
}
