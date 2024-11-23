import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class BookshelfPage extends GetView<BookshelfPageController>{
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BookshelfPageController(),
      id: 'bookshelfPage',
        builder:(_){
          return  Scaffold(
            appBar: AppBar(
                elevation: 0,
                titleSpacing: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 40.h,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     SizedBox(width: 18.sp),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        // 使宽度充满整个 Row
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppColor.search,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          // focusNode: controller.bookFocusNode,
                          controller: controller.bookTextEditingController,
                          onSubmitted: (val) {
                            if (val != '') {
                              // controller.handleSearch();
                              // controller.saveSearchHistory(val);
                            } else {
                              BrnToast.show("请输入漫画名字搜索~", context);
                            }
                          },
                          autofocus: false,
                          cursorColor: AppColor.defaultColor,
                          decoration: InputDecoration(
                            hintText: '搜索书架漫画',
                            hintStyle: TextStyle(
                              fontSize: 14.sp, // 或者使用你的字体大小
                              textBaseline: TextBaseline.alphabetic,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () {
                          if (controller.bookTextEditingController.text != '') {
                            controller.bookFocusNode.unfocus();
                            // controller.handleSearch();
                          } else {
                            BrnToast.show("请输入漫画名字搜索~", context);
                          }
                          // _saveSearchHistory(_textEditingController.text);
                        },
                        child: Text(
                          '搜索',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )),
            body: Align(
              child: Text(controller.userData.token),
            ),
          );
        }
    );
  }
}