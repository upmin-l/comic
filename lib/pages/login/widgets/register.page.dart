import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

import '../controller.dart';
import 'text.form.dart';

class RegisterPage extends GetView<LoginPageController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginPageController(),
      id: 'registerPage',
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffafafa),
            titleSpacing: 0,
            elevation: 0,
            toolbarHeight: 30.h,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColor.videoPrimary),
              // 设置返回键的颜色
              onPressed: () {
                controller.setShowPinPut(context);

              },

            ),
          ),
          // body: buildPinPut(),
          body: controller.showPinPut
              ? buildPinPut(context)
              : Form(
                  key: controller.registerFormKey,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/log.png'),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '请输入您的账号密码',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: AppColor.gray),
                                ),
                                const SizedBox(height: 10),
                                TextForm(
                                  controller:
                                      controller.registerEmailController,
                                  obscure: false,
                                  textInputType: TextInputType.text,
                                  text: '用户名/手机号/Email',
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '账号不能为空';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextForm(
                                  controller: controller.registerPawController,
                                  obscure: true,
                                  text: '请输入密码',
                                  textInputType: TextInputType.number,
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '密码不能为空';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextForm(
                                  controller:
                                      controller.registerConfirmPawController,
                                  obscure: true,
                                  text: '请确认输入密码',
                                  textInputType: TextInputType.number,
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '密码不能为空';
                                    }
                                    if (controller.registerPawController.text !=
                                        value) {
                                      return '密码输入不一致';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    controller.registerNext(context);
                                  },
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
                                      '下一步',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      if (controller.nextRegister)
                        Container(
                          color: Colors.white.withOpacity(0.8),
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: LoadingAnimationWidget.hexagonDots(
                              color: AppColor.defaultColor,
                              size: 40,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget buildPinPut(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.sp, bottom: 12.sp),
          child: Text('请输入邀请码',
              style: TextStyle(fontSize: 20.sp, color: AppColor.defaultColor)),
        ),
        Container(
          padding: EdgeInsets.all(10.sp),
          // alignment: Alignment.centerLeft,
          child: Text('邀请码请联系让您知道此软件的人',
              style: TextStyle(fontSize: 14.sp, color: AppColor.red)),
        ),
        Center(
          child: Pinput(
            onCompleted: (pin) {
              controller.pinPut = pin;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50.w,vertical: 20.h),
          child: InkWell(
            onTap: () {
              controller.register(context);
            },
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
              child: const Text('立即注册',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
