import 'package:comic/public.models.dart';

/// 主页  最近更新 模型
class RecentUpdateItem {
  final String href;
  final String img;
  final String upChapter;
  final String update;
  final String name;
  RecentUpdateItem(
      {required this.href,
      required this.update,
      required this.upChapter,
      required this.img,
      required this.name});

  factory RecentUpdateItem.fromJson(dynamic json) {
    return RecentUpdateItem(
      name: json["name"],
      img: json['img'],
      href: json['href'],
      upChapter: json['upChapter'],
      update: json['update'],
    );
  }
}

/// 18禁 漫画 接口 返回模型
class Comic18List {
  List<Comic18Item> list;

  Comic18List(this.list);

  factory Comic18List.toJson(List<dynamic> list) {
    return Comic18List(list.map((item) => Comic18Item.fromJson(item)).toList());
  }
}

class Comic18Item  {
  ///漫画名字
  final String name;
  ///漫画id

  final String id;

  /// 漫画 预览图
  final String pic;

  /// 漫画状态
  final String serialize;

  /// 漫画描述
  final String content;

  /// 漫画详情 url
  String url;

  /// 漫画第一章 名字
  final String chapter_name;

  /// 漫画第一章 url 详情页
  String chapter_url;

  /// 漫画类型 tags
  final List<String> tags;

  Comic18Item({
    required this.name,
    required this.pic,
    required this.url,
    required this.tags,
    required this.chapter_url,
    required this.chapter_name,
    required this.content,
    required this.id,
    required this.serialize,
  });

  factory Comic18Item.fromJson(dynamic json) {
    return Comic18Item(
      name: json['name'],
      pic: json['pic'],
      url: json['url'],
      tags: List<String>.from(json['tags']),
      chapter_url: json['chapter_url'],
      chapter_name: json['chapter_name'],
      content: json['content'],
      serialize: json['serialize'],
      id: json['id'],
    );
  }
}
/******************************* /// 18禁 漫画 接口 返回模型 end ************************************************/
