import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class BookshelfPage extends GetView<BookshelfPageController>{
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BookshelfPageController(),
      id: 'homePage',
        builder:(_){
          return  const Scaffold(
            body: Align(
              child: Text('漫画分类'),
            ),
          );
        }
    );
  }
}