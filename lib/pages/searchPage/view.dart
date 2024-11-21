import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/pages/comic/index.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'controller.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SearchPageController(),
      id: 'searchPage',
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              titleSpacing: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 40.h,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                ),
                color: AppColor.defaultColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back_ios),
                  //   color: AppColor.buttonColor,
                  //   onPressed: () {},
                  // ),
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
                        focusNode: controller.focusNode,
                        controller: controller.textEditingController,
                        onSubmitted: (val) {
                          if (val != '') {
                            controller.handleSearch();
                            controller.saveSearchHistory(val);
                          } else {
                            BrnToast.show("请输入漫画名字搜索~", context);
                          }
                        },
                        autofocus: true,
                        cursorColor: AppColor.defaultColor,
                        decoration: InputDecoration(
                          hintText: '请输入搜索内容',
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
                        if (controller.textEditingController.text != '') {
                          controller.focusNode.unfocus();
                          controller.handleSearch();
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
          body: controller.isSearch
              ? controller.searchInFinish
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.w, horizontal: 5.h),
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.6,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 3.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              childCount: controller.searchComicList.length,
                              (context, index) {
                                return GridViewList<ComicItem>(
                                  pathUrl: '/comicItemPage',
                                  item: controller.searchComicList[index],
                                  getName: (item) => item.name,
                                  getTopicImg: (item) => item.topic_img,
                                  getTypeNames: (item) => item.type_names,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: LoadingAnimationWidget.hexagonDots(
                          color: AppColor.defaultColor,
                          size: 40,
                        ),
                      ),
                    )
              : searchHistory(context),
        );
      },
    );
  }

  Widget searchHistory(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '搜索历史',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  if(controller.searchHistory.isEmpty){
                    BrnDialogManager.showConfirmDialog(
                      context,
                      cancel: "取消",
                      confirm: "确定",
                      title: '删除提示',
                      messageWidget: Padding(
                        padding:
                        const EdgeInsets.only(top: 6, left: 24, right: 24),
                        child: BrnCSS2Text.toTextView('你确定要全部删除搜索历史记录吗?此操作不可逆!'),
                      ),
                      barrierDismissible: false,
                      onCancel: () => Navigator.pop(context),
                      onConfirm: () {
                        controller.clearSearchHistory();
                        // BrnToast.show("支付成功！", context);
                        Navigator.pop(context);
                      },
                    );
                  }else{
                    BrnToast.show("您还没有搜索记录~", context);
                  }
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20.0,
                ),
              )
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 1,
              childAspectRatio: 5.5,
            ),
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, idx) {
              return InkWell(
                onTap: (){
                  controller.textEditingController.text = controller.searchHistory[idx];
                  controller.focusNode.unfocus();
                  controller.handleSearch();
                },
                child: Text(
                  controller.searchHistory[idx],
                  style: TextStyle(fontSize: 12.sp),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
