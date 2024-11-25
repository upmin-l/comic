import 'dart:async';
import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:comic/global.dart';
import 'package:comic/initPage.controller.dart';
import 'package:comic/public.models.dart';
import 'package:comic/routers/index.dart';
import 'package:comic/services.dart';
import 'package:comic/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../index.dart';

class Comic18ItemPageController extends GetxController
    with GetTickerProviderStateMixin {
  Comic18Item comic18Item = Get.arguments;
  TabController? chapterTab18Controller;

  final initPageController = Get.find<InitPageController>();
  final appGlobalServices = Get.find<AppGlobalServices>();

  late final WebViewController webViewController;
  late String comicInfoState = '未知';
  var btnObj = Rx<ComicChapterListItem>(ComicChapterListItem.fromJson({}));

  /// 全部章节
  List<ComicChapterListItem> comic18Chapters = [];

  /// 当前显示的章节
  List<ComicChapterListItem> tab18Contents = [];

  /// 动态生成的 tabs 标签
  List<Tab> tabs18 = [];

  /// 用于指示数据是否在加载
  bool isLoading = true;

  ///标记用户是否已经登录，能获取到token
  bool logOn = false;

  ///漫画是否是收藏
  RxBool isFavorite = false.obs;

  /// 用户保存漫画 模型
  SetComicStorageModel comicStorageModel = SetComicStorageModel.fromJson({});

  initData() {
    update(["comic18ItemPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    comicInfoState = comic18Item.serialize;
    logOn = UserData.getInstance.userData?.t != null;
    getChapter().then((value) {
      getComicStorage();
    });
  }

  Future getChapter() async {
    final completer = Completer<void>(); // 创建 Completer
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('get18Chapters',
          onMessageReceived: (JavaScriptMessage val) async {
        String a = val.message;
        List<dynamic> jsonMap = jsonDecode(a);
        var res = jsonMap
            .map<ComicChapterListItem>(
                (json) => ComicChapterListItem.fromJson(json))
            .toList();
        comic18Chapters.addAll(res);

        /// 动态计算 tab有多少个
        tabs18.addAll(generateTabs(jsonMap));

        chapterTab18Controller =
            TabController(vsync: this, length: tabs18.length);

        int start = 0;
        int end = 20;

        /// 默认显示1-20
        tab18Contents.addAll(comic18Chapters.sublist(start, end));

        setupTabListener(
          chapterTab18Controller,
          tabs18,
          comic18Chapters,
          initData,
          tab18Contents,
        );
        isLoading = false;
        initData();

        completer.complete(); // 标记任务完成
      })
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (controller) {
        webViewController.runJavaScript('''
            function get18ChaptersList() {
              const chapterListElement = document.querySelectorAll('.detail-list .detail-list-item a');
              const comicList = [];
              if (Array.from(chapterListElement).length > 1) {
                Array.from(chapterListElement).forEach((item) => {
                  let obj = { href: '', text: '', upTime: '' }
                  obj.href = item.href;
                  obj.text = item.innerText;
                  comicList.push(obj);
                });
              }
              return JSON.stringify(comicList);
            }
            
            get18Chapters.postMessage(get18ChaptersList()); 
            ''');
      }))
      ..loadRequest(Uri.parse(comic18Item.url));

    return completer.future; // 等待任务完成
  }

  /// 点击章节跳转阅读
  goToComicReaderPage(idx) {
    Get.toNamed(
      RouteNames.comicReaderPage,
      arguments: {
        'comicChapters': comic18Chapters,
        'index': (chapterTab18Controller!.index) * 20 + idx,
        'type': true,
        'comicInfoState': comicInfoState,
        'comic_id': comic18Item.id,
      },
    );
  }

  startComicReader() {
    Get.toNamed(
      RouteNames.comicReaderPage,
      arguments: {
        'comicChapters': comic18Chapters,
        'index': btnObj.value.index,
        'type': true,
        'comicInfoState': comicInfoState,
        'comic_id': comic18Item.id,
      },
    );
  }

  /// 获取单个漫画阅读历史
  Future getComicStorage() async {
    /// 先看是否登录
    if (UserData.getInstance.userData?.t != null) {
      appGlobalServices.getComicStorage(comic18Item.id).then((value) {
        if (value.href != '') {
          btnObj.value = value;
          isFavorite.value = true;
        } else {
          btnObj.value = ComicChapterListItem(
            text: btnObj.value.text, // 保持原来的 text
            href: comic18Chapters[0].href, // 更新为新的 href
            comic_id: comic18Item.id,
            index: 0,
            name: comic18Item.name,
            topic_img: comic18Item.pic,
          );
          isFavorite.value = false;
        }
        initData();
      });
    } else {}
  }

  /// 接受阅读页面保存历史的回调函数
  Future setStorage(ComicChapterListItem res) async {
    btnObj.value = res;

    /// 如果登录，就发送保存到后台
    if (logOn) {
      await initSetComicStorage();
      appGlobalServices.setComicStorage(comicStorageModel);
    }
  }

  Future initSetComicStorage() async {
    comicStorageModel.name = comic18Item.name;
    comicStorageModel.topic_img = comic18Item.pic;
    comicStorageModel.comic_id = comic18Item.id;
    comicStorageModel.chapter_name = btnObj.value.text;
    comicStorageModel.chapter_url = btnObj.value.href;
    comicStorageModel.index = btnObj.value.index;
  }

  /// 漫画收藏
  Future setComicStorage(BuildContext context) async {
    if (logOn) {
      if (isFavorite.value) {
        BrnToast.show("您已经收藏了此漫画！", context);
        return;
      }
      await initSetComicStorage();
      appGlobalServices.setComicStorage(comicStorageModel).then((value) {
        BrnToast.show(value.msg, context);
        isFavorite.value = true;
        initData();
      });
    } else {
      BrnToast.show("请先登录再进行收藏该漫画！", context);
    }
  }

  @override
  void onClose() {
    chapterTab18Controller?.dispose();
    super.onClose();
  }
}
