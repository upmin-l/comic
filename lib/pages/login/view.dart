
import 'package:app_launcher/app_launcher.dart';
import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../web.view.page.dart';
import 'controller.dart';
import 'widgets/register.page.dart';
import 'widgets/text.form.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginPageController(),
      id: 'loginPage',
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffafafa),
            titleSpacing: 0,
            elevation: 0,
            toolbarHeight: 30.h,
            leading: IconButton(
              icon: const Icon(Icons.clear, color: AppColor.videoPrimary),
              // 设置返回键的颜色
              onPressed: () {
                // 返回键点击事件
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 30),
                  //   child: SvgPicture.asset(
                  //     'assets/icons/log_icon.svg',
                  //     height: 50,
                  //   ),
                  // ),
                  const Image(
                    image: AssetImage('assets/images/log.png'),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '请输入您的账号密码',
                            style: TextStyle(
                                fontSize: 14.sp, color: AppColor.gray),
                          ),
                          const SizedBox(height: 15),
                          TextForm(
                            controller: controller.emailController,
                            obscure: false,
                            textInputType: TextInputType.text,
                            text: '账号',
                            icon: Icons.person,
                            validator: (val) {
                              // if (val == null || val.isEmpty) {
                              //   return '请输入用户名/手机号/Email';
                              // }
                              // // 添加更多的验证逻辑，例如检查Email格式
                              // if (!val.isEmail) {
                              //   return '请输入有效的Email地址';
                              // }
                              return null;
                            },
                          ),
                          const SizedBox(height: 6),
                          TextForm(
                            icon: Icons.lock,
                            controller: controller.pawController,
                            textInputType: TextInputType.number, // 设置键盘类型为数字键盘
                            obscure: true,
                            text: '请输入密码',
                          ),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       value: false,
                          //       onChanged: (va) {},
                          //       activeColor: AppColor.buttonColor,
                          //       checkColor: AppColor.red,
                          //     ),
                          //     RichText(
                          //       text: TextSpan(
                          //         text: '已阅读并同意',
                          //         children: [
                          //           TextSpan(text: '用户协议'),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              if(controller.emailController.text.isNotEmpty&&controller.pawController.text.isNotEmpty){
                                controller.login(context);
                              }else{
                                BrnToast.show("用户名或密码不能为空！", context);
                              }
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
                                '登录',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('还没有账号？', style: TextStyle(color: AppColor.gray)),
                InkWell(
                  onTap: () => Get.to(() => const RegisterPage(),
                      transition: Transition.rightToLeftWithFade),
                  child: const Text(
                    '立即注册!',
                    style: TextStyle(
                        color: AppColor.defaultColor, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
