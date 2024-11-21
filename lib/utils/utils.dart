


import 'package:comic/public.models.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';

Iterable<dynamic> pickRandomItems<T>(List<dynamic> items, int count) =>
    (items.toList()..shuffle()).take(count);

// tag 标签 获取 转换
handleTagsItem(List<dynamic> list, [int num = 3]) {
  List<TagsItem> arr = [];
  var newTypeName = pickRandomItems(list, num);
  for (int i = 0; i < newTypeName.length; i++) {
    TagsItem newItem = TagsItem(title: list[i], color: 0xFF3e4784);
    arr.add(newItem);
  }
  return arr;
}


/// 动态生成 章节tabs
List<Tab> generateTabs(List<dynamic> jsonResponse) {
  int chaptersPerTab = 20; // 每个 Tab 显示 20 个章节
  int tabCount = (jsonResponse.length / chaptersPerTab).ceil(); // 计算需要多少个 Tab
  List<Tab> tabs =[];
  for (int i = 0; i < tabCount; i++) {
    int start = i * chaptersPerTab + 1;
    int end = (i + 1) * chaptersPerTab > jsonResponse.length
        ? jsonResponse.length
        : (i + 1) * chaptersPerTab;

    tabs.add(customTab('$start-$end','$start,$end'));
  }
  return tabs;
}


void setupTabListener<T>(
    TabController? controller,
    List<Tab> tabs,
    List<dynamic> chapterList, // 替换为你的章节类型
    Function initData,
    List<dynamic> tabContents, // 替换为你的内容类型
    ) {
  controller?.addListener(() {
    if (!controller.indexIsChanging) {
      tabContents.clear();
      final Key? currentKey = tabs[controller.index].key;

      if (currentKey is ValueKey<String>) {
        // 解析 Key 中的 start 和 end
        List<String> parts = currentKey.value.split(',');
        int start = int.parse(parts[0]);
        int end = int.parse(parts[1]);

        tabContents.addAll(chapterList.sublist(start - 1, end));
        initData();
      }
    }
  });
}
