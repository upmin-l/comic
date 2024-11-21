import 'dart:convert';

import 'package:comic/public.models.dart';
import 'package:comic/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../comic/models.dart';
import '../index.dart';

class ComicItemPageController extends GetxController
    with GetTickerProviderStateMixin {
  ComicItem comicItem= Get.arguments;

  late final WebViewController webViewController;
  late final WebViewController webViewController2;
  TabController? chapterTabController;
  /// 全部章节
  List<ComicChapterListItem> comicChapters = [];
  /// 当前显示的章节
  List<ComicChapterListItem> tabContents = [];

  late String comicInfoName = '获取中..'; // 漫画描述
  late String comicInfoState = '未知'; // 漫画是否完结
  late String comicUpdateTimeLabel =''; // 漫画

  bool isLoading = true; // 用于指示数据是否在加载

  List<Tab> tabs = [];

  initData() {
    update(["comicItemPage"]);
  }

  @override
  void onInit() {
    super.onInit();

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

    getChapter();
  }

  // 获取当前 Tab 的内容
  // String _getCurrentContent(int tabIndex) {
  //   List<String> chapters = tabContents[tabIndex];
  //   return '当前章节: ${chapters.join(', ')}'; // 示例显示所有章节
  // }

  void getChapter() {
    // print('https://baozimh.org/chapterlist/${comicItem.comic_id}');
    webViewController2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'getChapters',
        onMessageReceived: (JavaScriptMessage message) async {

          /// TODO：bug 执行两次导致tabContents 重复添加，展示找不到问题，先以这种方法解决
          tabContents.clear();

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

            if(comicInfo.updateTimeLabel != null)comicUpdateTimeLabel = comicInfo.updateTimeLabel!;


            /// 动态计算 tab有多少个
            tabs.addAll(generateTabs(comicInfo.list));

            chapterTabController = TabController(vsync: this, length: tabs.length);

            int start = 0;
            int end = 20;
            tabContents.addAll(comicChapters.sublist(start,end));
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



  @override
  void onClose() {
    // webViewController.clearCache();
    // webViewController2.clearCache();
    chapterTabController?.dispose();
    super.onClose();
  }
}
