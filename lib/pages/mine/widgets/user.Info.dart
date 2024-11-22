
// 用户界面
import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/public.models.dart';
import 'package:comic/routers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget userInfo(context,UserModel data,bool isLogin) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft, // 渐变开始于容器的顶部中心
        end: Alignment.bottomCenter, // 渐变结束于容器的底部中心
        colors: [
          Color(0xFFfff2ec), // 十六进制颜色 #fff2ec 转换为 Flutter 的 Color
          Color(0xFFF0F1F6), // 十六进制颜色 #f0f1f6 转换为 Flutter 的 Color
          Color(0xFFE1F0FF), // 十六进制颜色 #e1f0ff 转换为 Flutter 的 Color
        ],
        stops: [0.0, 0.42, 1.0], // 定义渐变颜色的停止点
      ),
    ),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, // 渐变开始于容器的顶部中心
          end: Alignment.bottomCenter, // 渐变结束于容器的底部中心
          colors: [
            Colors.white,
            // 十六进制颜色 #fff 转换为 Flutter 的 Color
            Color.fromRGBO(247, 248, 249, 0),
          ],
          stops: [0.0, 0.5], // 定义渐变颜色的停止点
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                if(isLogin){
                  BrnToast.show("你已经登录", context);
                }else{
                  Get.toNamed(RouteNames.loginPage);
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    child: CircleAvatar(
                      radius: 27.0,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: const AssetImage('assets/images/user.png'),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(data.user, style: TextStyle(fontSize: 14.sp)),
                  const SizedBox(height: 4.0),
                  /// 账号未激活显示
                  Padding(
                    padding: EdgeInsets.only(left: 8.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image:  const AssetImage('assets/images/warn.png'),
                          width: 16.sp,
                          height: 16.sp,
                        ),
                        const SizedBox(width: 4.0),
                        const Text('账号未激活'),
                        const SizedBox(width: 4.0),
                        OutlinedButton(
                          onPressed: () {  },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            side: const BorderSide(width: 2, color: AppColor.red),
                          ),
                          child: const Text('点击激活'),

                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 40.0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text(
            //             '0.00',
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 3),
            //           Text(
            //             '总收入',
            //             style:
            //             TextStyle(fontSize: 10.sp, color: AppColor.gray),
            //           ),
            //         ],
            //       ),
            //       const VerticalDivider(width: 8.0),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text(
            //             '0.00',
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 3),
            //           Text(
            //             '昨日收入',
            //             style:
            //             TextStyle(fontSize: 10.sp, color: AppColor.gray),
            //           ),
            //         ],
            //       ),
            //       const VerticalDivider(width: 8.0),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text(
            //             '0.00',
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 3),
            //           Text(
            //             '今日已收入',
            //             style:
            //             TextStyle(fontSize: 10.sp, color: AppColor.gray),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SvgPicture.asset(
            //           'assets/icons/vx.svg',
            //           width: 20,
            //           height: 20,
            //         ),
            //         const SizedBox(width: 5),
            //         SvgPicture.asset(
            //           'assets/icons/zfb.svg',
            //           width: 20,
            //           height: 20,
            //         ),
            //         const SizedBox(width: 5),
            //         SvgPicture.asset(
            //           'assets/icons/USDTLOG.svg',
            //           width: 20,
            //           height: 20,
            //         ),
            //       ],
            //     ),
            //     TextButton.icon(
            //       onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //           content: Text('正在开发！'),
            //           duration: Duration(seconds: 2), // 显示时长
            //         ),
            //       ),
            //       icon: const Icon(
            //         Icons.wallet,
            //         color: AppColor.mainFontColor,
            //       ),
            //       label: Text(
            //         '充值 or 提现',
            //         style: TextStyle(
            //             color: AppColor.mainFontColor, fontSize: 12.sp),
            //       ),
            //       style: const ButtonStyle(
            //         splashFactory: NoSplash.splashFactory, // 取消水波纹效果
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    ),
  );
}