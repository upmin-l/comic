

import 'package:comic/public.models.dart';
import 'package:get/get.dart';


// class ComicBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ComicServices());
//   }
// }

class ComicServices extends GetConnect{
  static ComicServices get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }


  /// 获取漫画列表
  Future getComicList(GetComicParameter parameter) async {
    // cn.czmanga.com
    String url = 'https://cn.baozimhcn.com/api/bzmhq/amp_comic_list?type=${parameter.type}&region=${parameter.region}&filter=${parameter.filter}&page=${parameter.page}&limit=${parameter.limit}&language=cn';

    final res = await get(url);
    if (res.hasError) return Future.error(Exception(res.statusCode));
    return res.body['items'];
  }
}
