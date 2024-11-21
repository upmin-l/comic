import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models.dart';

class ModalList extends StatefulWidget {
  final ComicShowMode comicShowModeList;
  const ModalList({super.key, required this.comicShowModeList});

  @override
  State<ModalList> createState() => _ModalListState();
}

class _ModalListState extends State<ModalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 30.h,
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
            Text('筛选', style: TextStyle(fontSize: 14.sp, color: Colors.black)),
        leading: InkWell(
          onTap: ()=>Navigator.pop(context),
          child: Icon(
            Icons.expand_more,
            color: AppColor.defaultColor,
            size: 30.sp,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('国家', style: titleStyle.copyWith(fontSize: 14.sp)),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  childCount: widget.comicShowModeList.countryList.length,
                  (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.lightGray,
                    borderRadius: BorderRadius.circular(8), // 如果需要圆角
                  ),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                  child: Text(widget.comicShowModeList.countryList[index].name),
                );
              }),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('分类', style: titleStyle.copyWith(fontSize: 14.sp)),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                childCount: widget.comicShowModeList.classifyList.length,
                (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightGray,
                      borderRadius: BorderRadius.circular(8), // 如果需要圆角
                    ),
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                    child:
                        Text(widget.comicShowModeList.classifyList[index].name),
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffeaeaea), // 边框颜色
              width: 0.5, // 边框宽度
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.lightGray,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Text(
                  '清空',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColor.gray),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.defaultColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Text(
                  '确定',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget modalList(ComicShowMode comicShowModeList) {
//   return Scaffold(
//     body: Container(
//       width: double.infinity,
//       height: 880.h,
//       color: Colors.white,
//       child: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text('国家', style: titleStyle.copyWith(fontSize: 14.sp)),
//             ),
//           ),
//           SliverGrid(
//             delegate: SliverChildBuilderDelegate(
//                 childCount: comicShowModeList.countryList.length,
//                 (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: AppColor.lightGray,
//                   borderRadius: BorderRadius.circular(8), // 如果需要圆角
//                 ),
//                 alignment: Alignment.center,
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
//                 child: Text(comicShowModeList.countryList[index].name),
//               );
//             }),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 3,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text('分类', style: titleStyle.copyWith(fontSize: 14.sp)),
//             ),
//           ),
//           SliverGrid(
//             delegate: SliverChildBuilderDelegate(
//               childCount: comicShowModeList.classifyList.length,
//               (context, index) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: AppColor.lightGray,
//                     borderRadius: BorderRadius.circular(8), // 如果需要圆角
//                   ),
//                   alignment: Alignment.center,
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
//                   child: Text(comicShowModeList.classifyList[index].name),
//                 );
//               },
//             ),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 3,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//             ),
//           ),
//         ],
//       ),
//     ),
//     bottomNavigationBar: Container(
//       height: 60,
//       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(
//             color: Color(0xffeaeaea), // 边框颜色
//             width: 0.5, // 边框宽度
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppColor.lightGray,
//                 borderRadius: BorderRadius.circular(6),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                   )
//                 ],
//               ),
//               child: const Text(
//                 '清空',
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppColor.defaultColor,
//                 borderRadius: BorderRadius.circular(6),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                   )
//                 ],
//               ),
//               child: const Text(
//                 '确定',
//                 style:
//                     TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
