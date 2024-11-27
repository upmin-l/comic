import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller.dart';

Widget userClassification(MinePageController controller) {
  return Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 5.h),
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('游览历史',
                style:
                TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            // InkWell(
            //     onTap: () => Get.to(() => const HistoricRecords(),
            //         transition: Transition.rightToLeftWithFade),
            //     child: const Text('更多'))
          ],
        ),
        SizedBox(
          // height: 120.h,
          height: 80.h,
          child: const Align(child: Text('暂时未开发！敬请等待'),),
          // child: ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: 9,
          //   itemBuilder: (context, index) {
          //     if (index >= 8) {
          //       return InkWell(
          //         child: Container(
          //           margin: EdgeInsets.only(right: 8.w, top: 5.h),
          //           width: 80.w,
          //           color: AppColor.defaultColor,
          //           child: Center(
          //             child: Text(
          //               '查看更多',
          //               style: TextStyle(fontSize: 12.sp),
          //             ),
          //           ),
          //         ),
          //       );
          //     } else {
          //       return Container(
          //         width: 80.w,
          //         margin: EdgeInsets.only(right: 8.w, top: 5.h),
          //         child: Column(
          //           children: [
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(10),
          //               child: Image(
          //                 image:
          //                 const AssetImage('assets/images/0.jpg'),
          //                 width: 80.w,
          //                 height: 95.h,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             const SizedBox(height: 3),
          //             Text(
          //               '我的四个美女总裁老婆',
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(fontSize: 12.sp),
          //               maxLines: 1,
          //             )
          //           ],
          //         ),
          //       );
          //     }
          //   },
          // ),
        )
      ],
    ),
  );
}