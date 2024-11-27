import 'dart:async';
import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:comic/routers/names.dart';
import 'package:comic/services.dart';
import 'package:comic/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../comic/models.dart';
import '../index.dart';

class ComicItemPageController extends GetxController
    with GetTickerProviderStateMixin {
  ComicItem comicItem = Get.arguments;
  final appGlobalServices = Get.find<AppGlobalServices>();

  late final WebViewController webViewController;
  late final WebViewController webViewController2;
  TabController? chapterTabController;

  /// 全部章节
  List<ComicChapterListItem> comicChapters = [];

  /// 当前显示的章节
  List<ComicChapterListItem> tabContents = [];

  var btnObj = Rx<ComicChapterListItem>(ComicChapterListItem.fromJson({}));

  ///标记用户是否已经登录，能获取到token
  bool logOn = false;

  ///漫画是否是收藏
  RxBool isFavorite = false.obs;

  /// 用户保存漫画 模型
  SetComicStorageModel comicStorageModel = SetComicStorageModel.fromJson({});

  late String comicInfoName = '获取中..'; // 漫画描述
  late String comicInfoState = '未知'; // 漫画是否完结
  late String comicUpdateTimeLabel = ''; // 漫画

  bool isLoading = true; // 用于指示数据是否在加载

  List<Tab> tabs = [];

  initData() {
    update(["comicItemPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    logOn = UserData.getInstance.userData?.t != null;
    // webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..addJavaScriptChannel(
    //     'getInfo',
    //     onMessageReceived: (JavaScriptMessage message) async {
    //       final jsonMap = jsonDecode(message.message);
    //       comicInfoName = jsonMap['name'];
    //       comicInfoState = jsonMap['state'];
    //       initData();
    //     },
    //   )
    //   ..setNavigationDelegate(NavigationDelegate(onPageFinished: (controller) {
    //     webViewController.runJavaScript('''
    //             function getComicInfo(){
    //               const obj = {name:'',state:''};
    //               obj.name = document.querySelector('.comics-detail__desc')?.textContent.trim()||'无法获取漫画,请尝试切换路线或换源。。。';
    //               obj.state = document.querySelector('.comics-detail .l-content .comics-detail__info .tag-list .tag').textContent.trim()||'未知';
    //               return JSON.stringify(obj);
    //             }
    //             getInfo.postMessage(getComicInfo());
    //         ''');
    //   }))
    //   ..loadRequest(
    //       Uri.parse('https://cn.baozimh.com/comic/${comicItem.comic_id}'));
    // if(comicInfoName!='无法获取漫画,请尝试切换路线或换源。。。') {
    //
    //
    // }

    getChapter().then((value) {
      getComicStorage();
    });
  }

  // 获取当前 Tab 的内容
  // String _getCurrentContent(int tabIndex) {
  //   List<String> chapters = tabContents[tabIndex];
  //   return '当前章节: ${chapters.join(', ')}'; // 示例显示所有章节
  // }

  Future getChapter() async {
    final completer = Completer<void>(); // 创建 Completer
    // print('https://baozimh.org/chapterlist/${comicItem.comic_id}');
    webViewController2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'getChapters',
        onMessageReceived: (JavaScriptMessage message) async {
          /// TODO：bug 执行两次导致tabContents 重复添加，展示找不到问题，先以这种方法解决
          tabContents.clear();
          tabs.clear();

          String a = message.message;

          if (a == "false") {
            comicInfoName =
                "${comicItem.name} 中有部份或全部章节数据缺少，导致情节不连续影响您正常观看，我们将对 ${comicItem.name}漫画 进行屏蔽处理，给您带来不便，敬请谅解！";
          } else {
            Map<String, dynamic> jsonMap = jsonDecode(a);

            ComicInfoMode comicInfo = ComicInfoMode.fromJson(jsonMap);
            comicInfoState = comicInfo.state;
            comicInfoName = comicInfo.description;

            comicChapters.addAll(comicInfo.list);

            if (comicInfo.updateTimeLabel != null)
              comicUpdateTimeLabel = comicInfo.updateTimeLabel!;

            /// 动态计算 tab有多少个
            tabs.addAll(generateTabs(comicInfo.list));

            chapterTabController =
                TabController(vsync: this, length: tabs.length);

            int start = 0;
            int end = 20;
            tabContents.addAll(comicChapters.sublist(start, end));
            // for (var element in tabContents) {
            //   element.href = '${comicItem.comic_id}/${element.href}';
            // }

            setupTabListener(
              chapterTabController,
              tabs,
              comicChapters,
              initData,
              tabContents,
            );
            isLoading = false;
            initData();
            completer.complete(); // 标记任务完成
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (controller) {
          webViewController2.runJavaScript('''
            function getElementContent() {
                  let obj = {}
                  const tabList = document.querySelector('.comics-detail .l-content .supporting-text > div:not(.tag-list)');
                  if(tabList) obj.updateTimeLabel = tabList.querySelector('em').textContent.trim();
     
                  obj.state = document.querySelector('.comics-detail .l-content .comics-detail__info .tag-list .tag').textContent.trim()
                  
                  obj.description = document.querySelector('.comics-detail__desc').textContent.trim();
                  let chapterList = [];
                  let chapterItem =[];
                  
                  const chapters = Array.from(document.getElementsByClassName("comics-chapters"));
                  if(document.getElementById('chapter-items')){
                    chapterList = Array.from(document.getElementById('chapter-items').children).concat(Array.from(document.getElementById('chapters_other_list').children));
                    chapterList.forEach((item,idx)=>{
                      let items = {};
                      items.text = item.querySelector('a div span').textContent || '';  //章节名字
                      const [, sectionSlot, chapterSlot] = (item.querySelector('a').href || '').match(/section_slot=([0-9]*)&chapter_slot=([0-9]*)/);
                      const chapterId = sectionSlot + '_' + chapterSlot;
                      items.href = chapterId;
                      chapterItem.push(items);
                    });
                  }else if(chapters.length>1){
                   chapterItem = chapters.map(item=>{
                      const text = item.querySelector('span').textContent.trim();                  
                      const [, sectionSlot, chapterSlot] = (item.querySelector('a').href || '').match(/section_slot=([0-9]*)&chapter_slot=([0-9]*)/);
                      const href = sectionSlot + '_' + chapterSlot;
                      return {text,href}
                    })                    
                  }else{
                    return "false";
                  }
                  obj.list = chapterItem;
                  
                  return JSON.stringify(obj);
                }
                getChapters.postMessage(getElementContent());
            ''');
        }),
      )
      ..loadRequest(
          Uri.parse('https://cn.baozimh.com/comic/${comicItem.comic_id}'));
  }

  /// 获取单个漫画阅读历史
  Future getComicStorage() async {
    /// 先看是否登录
    if (UserData.getInstance.userData?.t != null) {
      appGlobalServices.getComicStorage(comicItem.comic_id).then((value) {
        if (value.href != '') {
          btnObj.value = value;
          isFavorite.value = true;
        } else {
          btnObj.value = ComicChapterListItem(
            text: btnObj.value.text, // 保持原来的 text
            href: comicChapters[0].href, // 更新为新的 href
            comic_id: comicItem.comic_id,
            index: 0,
            name: comicItem.name,
            topic_img: comicItem.topic_img,
          );
          isFavorite.value = false;
        }
        initData();
      });
    } else {}
  }

  Future initSetComicStorage() async {
    comicStorageModel.name = comicItem.name;
    comicStorageModel.topic_img = comicItem.topic_img;
    comicStorageModel.comic_id = comicItem.comic_id;
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

  /// 接受阅读页面保存历史的回调函数
  Future setStorage(ComicChapterListItem res) async {
    btnObj.value = res;

    /// 如果登录了并且用户手动收藏的漫画，就发送保存到后台
    if (logOn && isFavorite.value) {
      await initSetComicStorage();
      appGlobalServices.setComicStorage(comicStorageModel);
    }
  }

  startComicReader() {
    Get.toNamed(
      RouteNames.comicReaderPage,
      arguments: {
        'comicChapters': comicChapters,
        'index': btnObj.value.index,
        'type': false,
        'comicInfoState': comicInfoState,
        'comic_id': comicItem.comic_id,
      },
    );
  }

  @override
  void onClose() {
    // webViewController.clearCache();
    // webViewController2.clearCache();
    chapterTabController?.dispose();
    super.onClose();
  }
}
