

import 'package:comic/public.models.dart';
import 'package:get/get.dart';



class ComicItemServices extends GetConnect{
  static ComicItemServices get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }


  /// 获取漫画详情 info
  Future getComicInfo(GetComicParameter parameter) async {
    String url = 'https://cn.baozimh.com/api/bzmhq/amp_comic_list?type=${parameter.type}&region=${parameter.region}&filter=${parameter.filter}&page=${parameter.page}&limit=${parameter.limit}&language=cn';
    final res = await get(url);
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return res.body['items'];
  }
}
