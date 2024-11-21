import 'package:get_storage/get_storage.dart';

class LocalStorage<T> {
  final GetStorage box = GetStorage(); // 本地存储
  final String Function(T) getStoreKey; // 获取存储键值的回调函数

  LocalStorage({required this.getStoreKey});

  /// 保存数据到本地存储
  Future<void> saveToStore(T data) async {
    final key = getStoreKey(data);
    await box.write(key, data);
  }

  /// 从本地存储读取数据
  T? readFromStore(String key) {
    try {
      final data = box.read(key);
      return data != null ? data as T : null;
    } catch (e) {
      print("读取数据时出错: $e");
      return null;
    }
  }

  /// 更新本地存储中的数据
  Future<void> updateStore(String key, T newData) async {
    await box.write(key, newData);
  }

  /// 从本地存储删除数据
  Future<void> deleteFromStore(String key) async {
    await box.remove(key);
  }

  /// 清除所有本地存储数据
  Future<void> clearStore() async {
    await box.erase();
  }
}
