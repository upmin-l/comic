import 'dart:convert';

import 'package:comic/initPage.controller.dart';
import 'package:comic/public.models.dart';
import 'package:comic/routers/index.dart';
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

  late final WebViewController webViewController;
  late String comicInfoState = '未知';
  var btnObj =
      Rx<ComicChapterListItem>(ComicChapterListItem(text: '开始阅读', href: ''));

  /// 全部章节
  List<ComicChapterListItem> comic18Chapters = [];

  /// 当前显示的章节
  List<ComicChapterListItem> tab18Contents = [];

  /// 动态生成的 tabs 标签
  List<Tab> tabs18 = [];

  bool isLoading = true; // 用于指示数据是否在加载


  initData() {
    update(["comic18ItemPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    comicInfoState = comic18Item.serialize;

    getChapter();
    // TODO:读取数据，先看本地有没有token，请求后台，校验token是否过期，如果没有token，则账号还没开通
    // getLocalStorage();
  }

  getChapter() {
    print(comic18Item.url);
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
        btnObj.value = ComicChapterListItem(
          text: btnObj.value.text, // 保持原来的 text
          href: comic18Chapters[0].href, // 更新为新的 href
        );

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

  @override
  void onClose() {
    chapterTab18Controller?.dispose();
    super.onClose();
  }
}
