
import 'dart:async';

import 'package:comic/public.models.dart';
import 'package:get_storage/get_storage.dart';

/// 线上环境
// const String globalBaseUrl = 'https://s.ziyuanniu.top';

//本地环境
const String globalBaseUrl = 'http://192.168.1.7:3000';

// const bzmList  = 'https://cn.baozimh.com/api/bzmhq/amp_comic_list';  // 包子漫画


StreamController<int> loginStreamController = StreamController.broadcast();

/// 常量定义
class AppConstants {
  static const userStoreKey = 'user';
}


class UserData {
  //私有化构造函数
  UserData._();

  //创建全局单例对象
  static UserData getInstance = UserData._();

  UserModel? _userdata;

  // 获取用户数据
  UserModel? get userData => _userdata;

  //是否登录
  bool get isLogin => _userdata != null;

  final box = GetStorage();

  /// 读取本地用户数据
  Future<UserModel?> readUserFromStore() async {
    try {
      return UserModel.fromJson(box.read(AppConstants.userStoreKey));
    } catch (e) {
      return null;
    }
  }

  /// 用户登录后写入到本地存储中
  Future<void> writeUserToStore(UserModel val) async {
    await box.write(AppConstants.userStoreKey, val);
  }

  set setUserData(UserModel user) {
    _userdata = user;
    writeUserToStore(user);
  }

  Future init() async {
    final res = await readUserFromStore();
    if (res != null) {
      _userdata = res;
    }
  }

  void clear() {
    _userdata = null;
    box.remove(AppConstants.userStoreKey);
  }
}