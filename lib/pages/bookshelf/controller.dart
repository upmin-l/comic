
import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookshelfPageController extends GetxController{

  final FocusNode bookFocusNode = FocusNode();
  final bookTextEditingController = TextEditingController();

  late UserModel userData =
      UserData.getInstance.userData ?? UserModel.fromJson({});


  initData() {
    update(["bookshelfPage"]);
  }

  updateUserData(){
    userData = UserModel.fromJson({});
    initData();
  }

  @override
  void onInit() {
    super.onInit();
    //用来远程通知当前页面刷新 目前在登录页面有使用
    loginStreamController.stream.listen((event) {
      if (UserData.getInstance.userData != null) {
        userData = UserData.getInstance.userData!;
        initData();
      }
    });

  }
}