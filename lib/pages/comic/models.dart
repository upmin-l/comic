
class ComicList {
  List<ComicItem> list;

  ComicList(this.list);

  factory ComicList.toJson(List<dynamic> list) {
    return ComicList(list.map((item) => ComicItem.fromJson(item)).toList());
  }
}

class ComicItem{
  final String name;
  final String comic_id;
  final List<dynamic> type_names;
  final String region;
  final String region_name;
  final String author;
  String topic_img;

  ComicItem({
    required this.author,
    required this.comic_id,
    required this.name,
    required this.region,
    required this.region_name,
    required this.topic_img,
    this.type_names = const [],
  });

  factory ComicItem.fromJson(dynamic item) {
    return ComicItem(
      author: item['author'],
      comic_id: item['comic_id'],
      name: item['name'],
      region: item['region'],
      region_name: item['region_name'],
      topic_img: item['topic_img'],
      type_names: item['type_names'].map((name) => name).toList(),
    );
  }
}

/// 漫画 弹出框更多 模型
class ComicShowMode{
  final List<ListMode> countryList;
  final List<ListMode> classifyList;

  ComicShowMode({
    required this.countryList,
    required this.classifyList,
  });

  factory ComicShowMode.fromJson(item){
    return ComicShowMode(
      countryList: (item['countryList'] as List<dynamic>).map((name) => ListMode.fromJson(name)).toList(),
      classifyList: (item['classifyList'] as List<dynamic>).map((name) => ListMode.fromJson(name)).toList(),
    );
  }
}
class ListMode{
  final String name;
  final String region;
  final String? keyId;

  ListMode({
    required this.name,
    required this.region,
    this.keyId,
  });

  factory ListMode.fromJson(Map<String, dynamic> json) {
    return ListMode(
      name: json['name'],
      region: json['region'],
      keyId: json['keyId'],
    );
  }
}
/****************************************** 漫画 弹出框更多 模型 end*/