

import 'dart:convert';
import 'package:comic/pages/comic/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchPageController extends GetxController{

  final textEditingController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  late final WebViewController searchWebViewController;

  List<ComicItem> searchComicList = ComicList([]).list;

  List<String> searchHistory = [];

  /// 标记是否已经搜索，为true则显示搜索后的widget
  bool isSearch = false;

  bool searchInFinish = true;

  initData() {
    update(["searchPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
    searchWebViewController = WebViewController();
  }


  Future handleSearch() async{
    isSearch = true;
    searchInFinish = false;
    initData();
    searchWebViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ToSearch',
        onMessageReceived: (JavaScriptMessage message) {
          final res = jsonDecode(message.message);
          ComicList comicListMode = ComicList.toJson(res);
          searchComicList.addAll(comicListMode.list);
          searchInFinish = true;
          initData();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (controller) {
            searchWebViewController.runJavaScript("""
                function getComicList() {
                const doc = document.querySelectorAll('.classify-items > div');
                var arr = Array.from(Array.prototype.slice.call(doc, 0, 30));
                var comicList = arr.map(item => {
                  var card = item.querySelector('.comics-card__poster');
                  var comic_id = card.getAttribute('href').replace('/comic/').replace('undefined',"");
                  var name = card.getAttribute('title') || '未命名';
                  var topic_img = item.querySelector('.comics-card__poster > amp-img').getAttribute('src') || '';
                  var type_names = Array.from(item.querySelectorAll('.comics-card__poster .tabs .tab')).map(v => v.textContent.trim());
                  var authorElement = item.querySelector('.comics-card__info .tags');
                  var author = authorElement ? authorElement.textContent.trim() : '';             
                  return { name,comic_id, topic_img, type_names, author ,region:'',region_name:''};
                });
                return JSON.stringify(comicList)
              }
              ToSearch.postMessage(getComicList());
            """);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://cn.baozimh.com/search?q=${textEditingController.text}'));
  }


  void loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('searchHistory') ?? [];
    searchHistory = history;
    initData();
  }

  void saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 5) {
        history.removeLast();
      }
      await prefs.setStringList('searchHistory', history);
      searchHistory = history;

    }
  }

  void clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    searchHistory = [];
    initData();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}