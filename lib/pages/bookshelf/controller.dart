
import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:comic/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookshelfPageController extends GetxController{

  final FocusNode bookFocusNode = FocusNode();
  final bookTextEditingController = TextEditingController();

  final appGlobalServices = Get.find<AppGlobalServices>();

  late UserModel userData =
      UserData.getInstance.userData ?? UserModel.fromJson({});

  late List<ComicChapterListItem> bookshelfList =  ComicChapterList.toJson([]).list;

  /// 暂时提示语
  String msg = '暂时未开放！敬请等待';

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
    getBookshelfList();
  }

  Future getBookshelfList()async{
    if(userData.t!=''){
      bookshelfList = await appGlobalServices.getBookshelfList();
      print(bookshelfList.length);
      for (int i = 0; i < bookshelfList.length; i++) {
        // Comic18List.
        // comicListMode.list[i].topic_img =
        // 'https://static-tw.baozimh.com/cover/${comicListMode.list[i].topic_img}';
      }
      initData();
    }
  }
}