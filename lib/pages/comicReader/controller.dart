import 'dart:async';
import 'dart:convert';

import 'package:comic/public.models.dart';
import 'package:comic/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../index.dart';

class ComicReaderPageController extends GetxController
    with GetTickerProviderStateMixin {
  final args = Get.arguments;
  late List<ComicChapterListItem> comicChapters;
  late String comicInfoState = '未知'; // 漫画是否完结
  late bool is18;
  late int index;

  ComicReaders comicReaders = ComicReaders(
    imgList: [],
    isNext: false,
    msg: '下一章',
    prve: '上一章',
    hash: '',
    sectionSlot: '',
    chapterSlot: '',
    pageSlot: 1,
    prvePageSlot: 0,
    comic_id: '',
  );

  List<dynamic> comicListImg = [];

  /// 缓存上一页/上一回
  List<List<dynamic>> prevListImg = [];

  bool hasCalledGetImg = false;
  bool isLoading = true;

  late final WebViewController webViewController;

  var comic18Storage;

  ScrollController scrollController = ScrollController();

  late AnimationController menuAnimationController;
  late Animation<Offset> menuTopAnimationProgress;
  late Animation<Offset> menuBottomAnimationProgress;

  void handleShowMenu() {
    menuAnimationController.isCompleted
        ? menuAnimationController.reverse()
        : menuAnimationController.forward();
  }

  initData() {
    update(["comicReaderPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    comicChapters = args['comicChapters'];
    is18 = args['type'];
    index = args['index'];
    comicInfoState = args['comicInfoState'];
    comicReaders.comic_id = args['comic_id'];

    comic18Storage = LocalStorage<ComicChapterListItem>(
      getStoreKey: (val) => 'comic18Chapter${args['comic_id']}',
    );

    webViewController = WebViewController();
    menuAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    menuTopAnimationProgress = menuAnimationController
        .drive(Tween(begin: const Offset(0.0, -1.0), end: Offset.zero));

    menuBottomAnimationProgress = menuAnimationController
        .drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero));

    late String url = '';

    if (!is18) {
      url =
          'https://cn.czmanga.com/comic/chapter/${comicReaders.comic_id}/${comicChapters[index].href}.html';
    } else {
      url = comicChapters[index].href;
    }

    getComicImg(url).then((value) {
      isLoading = false;
      initData();
    });

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        menuAnimationController.forward();
      }
    });
  }

  Future<void> getComicImg(String url) {
    print(url);
    final Completer<void> completer = Completer<void>();
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'imgList',
        onMessageReceived: (JavaScriptMessage val) async {
          /// TODO：bug 执行两次导致tabContents 重复添加，展示找不到问题，先以这种方法解决
          comicListImg.clear();

          if (is18) {
            List<dynamic> jsonMap = jsonDecode(val.message);
            comicListImg.addAll(jsonMap);

            /// 缓存数据
            // addPage(jsonMap);
          } else {
            // 将 val.message 解码为 JSON
            Map<String, dynamic> jsonMap = jsonDecode(val.message);

            // 将 JSON 转换为 ComicReaders 实例
            comicReaders = ComicReaders.fromJson(jsonMap);

            comicListImg.addAll(comicReaders.imgList);

            /// 缓存数据
            // addPage(comicReaders.imgList);
          }
          completer.complete(); // 完成 Completer，表示操作已完成

          // initData();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (controller) {
            if (!hasCalledGetImg) {
              if (is18) {
                get18Img();
              } else {
                getImg();
              }
              hasCalledGetImg = true; // 设置标志，防止后续重复调用
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return completer.future; // 返回 Completer 的 future
  }

  getImg() {
    webViewController.runJavaScript('''
    function fn() {
        const obj = {
            imgList: [],
            isNext: false,
            msg: 'ok',
            prve:'',
            hash: '',
            sectionSlot: '',
            chapterSlot: '',
            pageSlot: 1
        };
        const allLinks = document.querySelectorAll('.bottom-bar .bottom-bar-tool .l-content a');
        // 获取上一回下一回 元素
        const linksWithId = Array.from(allLinks).filter(link => link.id || link.classList.contains('disable'));
        /// 获取下一回/下一页 元素
        const next = linksWithId.at(-1);
        
        /// 获取上一回/上一页 元素
        const prve =linksWithId[0];
    
        const [, hash, sectionSlot, chapterSlot, pageSlot] = next.href.match(/\\/[^_/]+_?([^/]*)\\/([0-9]*)_([0-9]*)_?([0-9]*)\\.html/) || []
        const [, prveHash, prveSectionSlot, prveChapterSlot, prvePageSlot] = prve.href.match(/\\/[^_/]+_?([^/]*)\\/([0-9]*)_([0-9]*)_?([0-9]*)\\.html/) || []
        obj.msg = next.textContent?.trim();
        obj.prve =prve.textContent?.trim();
        obj.isNext = next.textContent?.includes('下一页');
        obj.hash = hash;
        obj.chapterSlot = chapterSlot;
        obj.sectionSlot = sectionSlot;
        obj.pageSlot = Number(pageSlot)||0;
        obj.prvePageSlot = Number(prvePageSlot)||0;
        if(next.href==='javascript:;')obj.msg = '已是最新章节';
        if(prve.href==='javascript:;')obj.prve = '已是第一章';
        const imgs = Array.from(document.querySelectorAll('.comic-contain > div:not(#div_top_ads):not(.mobadsq)'))
        imgs.forEach((item) => {
            const ampImg = item.querySelector('amp-img')
            obj.imgList.push(ampImg.getAttribute('src'))
        })
    
        return JSON.stringify(obj);
    }
    imgList.postMessage(fn()); 
     ''');
  }

  get18Img() {
    webViewController.runJavaScript('''
            function get18ImgList() {
              const list = Array.from(document.querySelectorAll('.view-main-1 img'));
              const res = [];
              list.forEach((item) => {
                res.push(item.src||'');
              })
              return JSON.stringify(res);
            }
            imgList.postMessage(get18ImgList()); 
            ''');
  }

  /// 阅读的时候章节选取
  onEvent(int idx) {
    var url = '';
    isLoading = true;
    hasCalledGetImg = false;
    initData();
    if (is18) {
      url = comicChapters[idx].href;
    } else {
      url =
          'https://cn.czmanga.com/comic/chapter/${args['comic_id']}/${comicChapters[idx].href}.html';
    }
    getComicImg(url).then((value) {
      scrollController.jumpTo(0); // 滚动到顶部
      menuAnimationController.reverse();
      isLoading = false;
      index = idx;
      initData();
    });
  }

  addPage(List<dynamic> currentPage) {
    prevListImg.add(currentPage);

    // 保持二维数组最多存两页数据
    if (prevListImg.length > 2) {
      prevListImg.removeAt(0);
    }
  }

  // 获取上一页的图片列表
  List<dynamic>? getPreviousPageImages() {
    if (prevListImg.length >= 2) {
      return prevListImg[prevListImg.length - 2];
    }
    return null;
  }

  /// 点击上一页/上一回 事件处理
  void onPreviousPage() {
    hasCalledGetImg = false;
    isLoading = true;
    initData();
    if (comicReaders.prve == '已是第一章') {
      isLoading = false;
      initData();
      return;
    }

    // 判断是否有上一页，如果没有才减 index
    var hasNextPage = false;

    if (comicReaders.prve == '上一页') {
      hasNextPage = true;
    }

    if (!hasNextPage) index -= 1;
    // 根据条件生成 URL
    final url = generateUrl(hasNextPage, comicReaders.prvePageSlot);

    // 获取漫画图像
    getComicImg(url).then((value) {
      scrollController.jumpTo(0); // 滚动到顶部
      isLoading = false;
      menuAnimationController.reverse();
      initData();
    }).catchError((err) {
      isLoading = false;
      initData();
    });
  }

  /// 点击下一页/下一回 事件处理
  void onNextPage() {
    hasCalledGetImg = false;
    isLoading = true;
    initData();
    if (comicReaders.msg == '已是最新章节') {
      isLoading = false;
      initData();
      return;
    }
    // 检查是否有更多章节
    if (index <= comicChapters.length - 1) {
      // 判断是否有下一页，如果没有才增加 index
      final bool hasNextPage = comicReaders.isNext;
      if (!hasNextPage) index += 1;

      // 根据条件生成 URL
      final url = generateUrl(hasNextPage, comicReaders.pageSlot);

      // 获取漫画图像
      getComicImg(url).then((value) {
        scrollController.jumpTo(0); // 滚动到顶部
        isLoading = false;
        menuAnimationController.reverse();
        initData();
      }).catchError((err) {
        isLoading = false;
        initData();
      });
    } else {
      print("No more chapters available.");
    }
  }

  /// 生成下一页/下一回的 URL
  String generateUrl(bool hasNextPage, pageSlot) {
    if (is18) return comicChapters[index].href;

    final base = 'https://cn.czmanga.com/comic/chapter/${args['comic_id']}';
    final chapterHref = comicChapters[index].href;

    return hasNextPage
        ? '$base/${chapterHref}_$pageSlot.html'
        : '$base/$chapterHref.html';
  }

  // /// 写入到本地存储中
  // Future<void> writeUserToStore(ComicChapterListItem val) async {
  //   await box18.write('comic18Chapter', val);
  // }

  @override
  void onClose() {
    var controller;

    if (is18) {
      controller = Get.find<Comic18ItemPageController>();
    } else {
      controller = Get.find<ComicItemPageController>();
    }

    // 使用 microtask 延迟更新数据，确保页面完全关闭后再触发 UI 更新
    Future.microtask(() async {
      await comic18Storage.saveToStore(comicChapters[index]);
      controller.btnObj.value = comicChapters[index];
    });
    prevListImg = [];
    menuAnimationController.dispose(); // 释放动画控制器
    scrollController.dispose(); // 释放滚动控制器
    comicListImg.clear();
    super.onClose();
  }
}
