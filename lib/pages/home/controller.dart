
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models.dart';
import 'services.dart';

class HomePageController extends GetxController with GetTickerProviderStateMixin{

  final comic18Services = Get.find<Comic18Services>();

  GetComicParameter getComic18Parameter = GetComicParameter(
    type: 'all',
    region: 'cn',
    filter: '*',
    page: 1,
    limit: 12,
  );

  List<Comic18Item> comic18List = Comic18List([]).list;

  late TabController homeTabController;

  List<Tab> homeTabs = [
    const Tab(text: '漫画'),
    const Tab(text: '小说'),
  ];

  @override
  void onInit() {
    super.onInit();
    homeTabController = TabController(vsync: this, length: homeTabs.length);
    getComicList();
  }


  Future getComicList() async {
    comic18Services.getComicList(getComic18Parameter).then((value){
      if(value.code==200){
        for(int i = 0; i<value.data.length;i++){
          value.data[i].url = 'https://www.hanmanmianfei.net/${value.data[i].url}';
          value.data[i].chapter_url = 'https://www.hanmanmianfei.net/${value.data[i].chapter_url}';
        }
        comic18List.addAll(value.data);
        update(['comic18Page']);
      }
    }).catchError((e){

    });
  }
}