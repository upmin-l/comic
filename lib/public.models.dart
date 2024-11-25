import 'package:comic/pages/index.dart';
import 'package:flutter/material.dart';

/// 我的功能列表模型
class MineList {
  int key;
  String name;
  IconData icon;

  ///是否路由跳转
  bool? jumpTo;

  MineList({
    required this.name,
    required this.key,
    required this.icon,
    this.jumpTo,
  });
}

class ListData {
  ///名字
  String name;

  /// icon
  IconData? icon;

  ///需要显示的文字
  String? msg;

  ///是否在后面显示icon
  bool? shouEndIcon;

  /// 标记唯一ID
  int id;

  ListData({
    required this.name,
    required this.id,
    this.icon,
    this.msg,
    this.shouEndIcon,
  });
}
/*——————————————————————————————————— 我的功能列表模型 end—————————————————————————————————————————————————————*/

/// 响应 格式
class ComicResponse {
  final int code;
  final String msg;
  final List<Comic18Item> data;

  ComicResponse({required this.code, required this.data, required this.msg});

  // 添加一个 fromJson 方法来解析 JSON 数据
  factory ComicResponse.fromJson(Map<String, dynamic> json) {
    return ComicResponse(
      code: json['code'],
      msg: json['msg'],
      // 判断 data 是否为空对象，如果是则赋值为空列表
      data: (json['data'] is List)
          ? (json['data'] as List)
              .map((item) => Comic18Item.fromJson(item))
              .toList()
          : [], // 如果 data 是空对象，则返回空列表
    );
  }
}

/// 圆形卡片 展示 模型

class CircularCardMode {
  List<RoleItem> list;

  CircularCardMode(this.list);

  factory CircularCardMode.toJson(List<dynamic> list) {
    return CircularCardMode(
        list.map((item) => RoleItem.fromJson(item)).toList());
  }
}

class RoleItem {
  final String portraitUrl;
  final String roleName;
  final String? key;

  RoleItem({required this.portraitUrl, required this.roleName, this.key = ''});

  // Story copyWith({required String url}) => Story(url: url);

  factory RoleItem.fromJson(dynamic json) {
    return RoleItem(
      portraitUrl: json["portraitUrl"],
      roleName: json['roleName'],
      key: json['key'],
    );
  }
}
/*——————————————————————————————————— 圆形卡片 展示 模型 end—————————————————————————————————————————————————————*/

// 漫画列表 请求参数类

class GetComicParameter {
  String type;
  String region;
  String filter;
  int page;
  int limit;
  String? random;

  GetComicParameter({
    required this.type,
    required this.region,
    required this.filter,
    required this.page,
    required this.limit,
    this.random,
  });

  // 将参数转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'region': region,
      'filter': filter,
      'page': page.toString(),
      'limit': limit.toString(),
      'random': random,
    };
  }
}

// tag 标签模型
class TagsItem {
  final String title;
  final int color;

  TagsItem({required this.title, required this.color});

  factory TagsItem.fromJson(dynamic json) {
    return TagsItem(
      title: json["title"],
      color: json['color'],
    );
  }
}

class ComicInfoMode {
  String description;
  final String? updateTimeLabel;
  final String state;
  final List<ComicChapterListItem> list;

  ComicInfoMode({
    required this.description,
    this.list = const [],
    required this.state,
    this.updateTimeLabel,
  });

  factory ComicInfoMode.fromJson(dynamic item) {
    return ComicInfoMode(
      description: item['description'],
      updateTimeLabel: item['updateTimeLabel'],
      state: item['state'],
      list: ComicChapterList.toJson(item['list']).list,
    );
  }
}

class ComicChapterList {
  List<ComicChapterListItem> list;

  ComicChapterList(this.list);

  factory ComicChapterList.toJson(List<dynamic> list) {
    return ComicChapterList(
        list.map((item) => ComicChapterListItem.fromJson(item)).toList());
  }
}

class ComicChapterListItem {
  final String text;
  final String href;
  final String comic_id;
  final String name;
  final String topic_img;
  late int index;

  ComicChapterListItem({
    required this.text,
    required this.href,
    required this.comic_id,
    required this.index,
    required this.name,
    required this.topic_img,
  });

  factory ComicChapterListItem.fromJson(dynamic item) {
    return ComicChapterListItem(
      text: item['text'] ?? '开始阅读',
      href: item['href'] ?? '',
      name: item['name'] ?? '',
      topic_img: item['topic_img'] ?? '',
      comic_id: item['comic_id'] ?? '',
      index: item['index'] ?? 0,
    );
  }
}

/// 漫画阅读 统一模型
class ComicReaders {
  final List<dynamic> imgList; // 当前阅读 的漫画 img
  final bool isNext; // 是否有下一页
  final String msg; // 信息
  final String? hash; // hash
  final String? sectionSlot; // 当前漫画的标识符
  final String? chapterSlot; // 当前漫画章节的标识章节
  late int pageSlot; // 当前漫画页数 如0_788_1,0_788_2,0_788_3
  late int prvePageSlot;
  final String prve;
  late String? comic_id;

  ComicReaders({
    required this.imgList,
    required this.isNext,
    required this.msg,
    required this.prve,
    this.hash = '',
    this.sectionSlot = '',
    this.chapterSlot = '',
    required this.pageSlot,
    required this.prvePageSlot,
    this.comic_id,
  });

  factory ComicReaders.fromJson(dynamic json) {
    return ComicReaders(
        imgList: json["imgList"],
        isNext: json['isNext'],
        prve: json['prve'],
        msg: json['msg'],
        hash: json['hash'],
        sectionSlot: json['sectionSlot'],
        chapterSlot: json['chapterSlot'],
        pageSlot: json['pageSlot'],
        comic_id: json['comic_id'],
        prvePageSlot: json['prvePageSlot']);
  }
}

class UserModel {
  final String user;
  final String t;
  final String authPhoto;
  final String id;
  final String type;

  UserModel({
    required this.user,
    required this.t,
    required this.authPhoto,
    required this.id,
    required this.type,
  });

  UserModel.fromJson(Map<String, dynamic> item)
      : user = item['user'] ?? '未登录',
        t = item['t'] ?? '',
        id = item['id'] ?? '',
        type = item['type'] ?? 'no',
        authPhoto = item['authPhoto'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      't': t,
      'authPhoto': authPhoto,
      'type': type,
      'id': id,
    };
  }
}

class ResponseModel {
  final int code;
  final String msg;
  final UserModel data;

  ResponseModel({
    required this.msg,
    required this.code,
    required this.data,
  });

  factory ResponseModel.fromJson(dynamic item) {
    return ResponseModel(
      code: item['code'],
      msg: item['msg'],
      data: UserModel.fromJson(item['data']),
    );
  }
}

class CustomerModel {
  final String type;
  final String wx;
  final String qq;
  final String show_url;
  final String tap_url;
  final CustomerModelData data;
  final String description;

  CustomerModel({
    required this.type,
    required this.wx,
    required this.show_url,
    required this.qq,
    required this.tap_url,
    required this.data,
    required this.description,
  });

  factory CustomerModel.fromJson(dynamic item) {
    return CustomerModel(
      type: item['type'] ?? '',
      wx: item['wx'] ?? '',
      show_url: item['show_url'] ?? '',
      qq: item['qq'] ?? '',
      tap_url: item['tap_url'] ?? '',
      description: item['description'] ?? '',
      data: CustomerModelData.fromJson(item['data'] ?? {}),
    );
  }
}

class CustomerModelData {
  final int size;
  final String version;
  final String md5;

  CustomerModelData({
    required this.version,
    required this.size,
    required this.md5,
  });

  factory CustomerModelData.fromJson(dynamic item) {
    return CustomerModelData(
      size: item['size'] ?? 0,
      version: item['version'] ?? '',
      md5: item['md5'] ?? '',
    );
  }
}

class SetComicStorageModel {
  late String name;
  late String topic_img;
  late String type_names;
  late String comic_id;
  late String region;
  late String chapter_name;
  late String chapter_url;
  late int index;

  SetComicStorageModel({
    required this.name,
    required this.topic_img,
    required this.type_names,
    required this.comic_id,
    required this.region,
    required this.chapter_name,
    required this.chapter_url,
    required this.index,
  });

  factory SetComicStorageModel.fromJson(dynamic item) {
    return SetComicStorageModel(
      name: item['name'] ?? '',
      topic_img: item['topic_img'] ?? '',
      type_names: item['type_names'] ?? '',
      comic_id: item['comic_id'] ?? '',
      region: item['region'] ?? '',
      chapter_name: item['chapter_name'] ?? '',
      chapter_url: item['chapter_url'] ?? '',
      index: item['index'] ?? 0,
    );
  }
  // 将参数转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'topic_img': topic_img,
      'type_names': type_names,
      'comic_id': comic_id.toString(),
      'region': region.toString(),
      'chapter_name': chapter_name,
      'chapter_url': chapter_url,
      'index': index,
    };
  }
}

class TokenModel {
  late String user;
  late String id;
  late String t;

  TokenModel({
    required this.user,
    required this.id,
    required this.t,
  });

  factory TokenModel.fromJson(dynamic item) {
    return TokenModel(
      user: item['user'] ?? '',
      id: item['id'] ?? '',
      t: item['t'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      't': t,
      'id': id,
    };
  }
}
