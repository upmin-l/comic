import 'package:comic/app_theme.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'models.dart';
import 'services.dart';

class ComicPageController extends GetxController
    with GetTickerProviderStateMixin {
  final comicServices = Get.find<ComicServices>();

  List<ComicItem> comicList = ComicList([]).list;

  late TabController topTabController;
  final List<Tab> topList = [
    Tab(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.search,
          borderRadius: BorderRadius.circular(5), // 如果需要圆角
        ),
        child: const Text('推荐'),
      ),
    ),
    Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp,vertical: 4.sp),
        decoration: BoxDecoration(
          color: AppColor.search,
          borderRadius: BorderRadius.circular(5), // 如果需要圆角
        ),
        child: const Text('推荐'),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.search,
          borderRadius: BorderRadius.circular(5), // 如果需要圆角
        ),
        child: const Text('推荐'),
      ),
    ),
  ];

  GetComicParameter getComicParameter = GetComicParameter(
    type: 'all',
    region: 'cn',
    filter: '*',
    page: 1,
    limit: 36,
  );
  // 创建ListMode实例作为国家列表数据
  List<ListMode> countryList = [
    ListMode(name: '国漫', region: 'cn'),
    ListMode(name: '日本', region: 'jp'),
    ListMode(name: '韩国', region: 'kr'),
    ListMode(name: '欧美', region: 'en'),
  ];

  // 创建ListMode实例作为分类列表数据
  List<ListMode> classifyList = [
    ListMode(name: '全部', region: 'Genre'),
    ListMode(name: '恋爱', region: 'Genre'),
    ListMode(name: '纯爱', region: 'Genre'),
    ListMode(name: '古风', region: 'Genre'),
    ListMode(name: '异能', region: 'Genre'),
    ListMode(name: '悬疑', region: 'Genre'),
    ListMode(name: '剧情', region: 'Genre'),
    ListMode(name: '科幻', region: 'Genre'),
    ListMode(name: '奇幻', region: 'Genre'),
    ListMode(name: '玄幻', region: 'Genre'),
    ListMode(name: '穿越', region: 'Genre'),
    ListMode(name: '冒险', region: 'Genre'),
    ListMode(name: '推理', region: 'Genre'),
    ListMode(name: '武侠', region: 'Genre'),
    ListMode(name: '格斗', region: 'Genre'),
    ListMode(name: '战争', region: 'Genre'),
    ListMode(name: '热血', region: 'Genre'),
    ListMode(name: '搞笑', region: 'Genre'),
    ListMode(name: '大女主', region: 'Genre'),
    ListMode(name: '都市', region: 'Genre'),
    ListMode(name: '总裁', region: 'Genre'),
    ListMode(name: '后宫', region: 'Genre'),
    ListMode(name: '日常', region: 'Genre'),
    ListMode(name: '韩漫', region: 'Genre'),
    ListMode(name: '少年', region: 'Genre'),
    ListMode(name: '其他', region: 'Genre'),
  ];

  ComicShowMode comicShowModeList = ComicShowMode(
      countryList: [],
      classifyList: []
  );

  bool comicPageLoading = true;

  ScrollController comicScrollController = ScrollController();

  Map<String, String> res = {
    '0': 'all',  //全部
    '1': 'xuanhuan', //玄幻
    '2':'lianai', //恋爱
    '3': 'hougong', // 后宫
    '4': 'gufeng', // 古风
    '5':'danuzhu', //大女主
    '6':'chuanyue', //穿越
  };


  initData() {
    update(["comicPage"]);
  }

  @override
  void onInit() {
    super.onInit();
    topTabController = TabController(vsync: this, length: 7);
    topTabController.addListener(()=>{

    });

    getComicList();
    comicShowModeList = ComicShowMode(
        countryList: countryList,
        classifyList: classifyList
    );
  }

  @override
  void onClose() {
    topTabController.dispose();
    comicScrollController.dispose();
    super.onClose();
  }

  /// 处理tab 切换时请求不同数据
  void handleGetData(int tabIdx) {
    comicPageLoading =true;
    initData();
    String idx = tabIdx.toString();
    comicList = [];
    getComicParameter.type =res[idx]!;
    getComicList();
  }


  Future getComicList() async {
    // comicList = [];
    comicServices.getComicList(getComicParameter).then((value) {
      ComicList comicListMode = ComicList.toJson(value);
      if(comicListMode.list.isNotEmpty){
        for (int i = 0; i < comicListMode.list.length; i++) {
          comicListMode.list[i].topic_img =
          'https://static-tw.baozimh.com/cover/${comicListMode.list[i].topic_img}';
        }
        comicList.addAll(comicListMode.list);
        comicPageLoading = false;
        initData();
      }else{
      }
    });
  }
}
