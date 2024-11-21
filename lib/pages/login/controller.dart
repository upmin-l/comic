import 'package:bruno/bruno.dart';
import 'package:comic/global.dart';
import 'package:comic/initPage.controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services.dart';

class LoginPageController extends GetxController {
  final loginServices = Get.find<LoginServices>();
  final initPageController = Get.find<InitPageController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pawController = TextEditingController();

  /// 注册页面用到
  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPawController = TextEditingController();
  final TextEditingController registerConfirmPawController = TextEditingController();
  bool nextRegister = false;
  bool showPinPut = false;
  late String pinPut = '1';

  final formKey = GlobalKey<FormState>();

  Future<void> onOpenUrl(String url) async {
    Uri uri = Uri.parse('https://qm.qq.com/cgi-bin/qm/qr?k=$url');
    if (!await canLaunchUrl(uri)) throw Exception('错误');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('无法唤起 QQ，请检查 QQ 是否安装');
    }
  }

  Future<void> copy(String? text) async {
    Clipboard.setData(ClipboardData(text: text ?? ''));
  }

  Future<void> login(context) async {
    loginServices
        .signIn(emailController.text, pawController.text)
        .then((value) {
      if (value.code == 200) {
        UserData.getInstance.setUserData = value.data;

        /// 登录成功后取消校验
        initPageController.isFirstTime =true;
        //发送消息更新我的页面显示内容
        loginStreamController.add(0);
        BrnToast.show("登录成功！", context);
        Navigator.pop(context);
      }else{
        BrnToast.show(value.msg, context);
      }
    }).catchError((e) {
      BrnToast.show('登录失败！$e', context);
    });
  }


  ///注册

  Future register(context)async{
    var deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.id);
    return;
    if(pinPut!='1'){
      loginServices.register(registerEmailController.text, registerPawController.text, pinPut).then((value) {
        if(value.code==200){
          pinPut = '';
          BrnToast.show(value.msg, context);
          Navigator.pop(context);
        }else{
          BrnToast.show(value.msg, context);
        }
      }).catchError((e){
        BrnToast.show('注册失败！$e', context);
      });
    }
  }

  /// 注册下一步
  Future registerNext(BuildContext context) async{
    nextRegister = true;
    if(registerFormKey.currentState!.validate()){
      loginServices.getUser(registerEmailController.text).then((value){
        nextRegister = false;
        if(value=='true'){
          BrnToast.show('此用户名已经被注册了', context);
        }else{
          showPinPut =true;
        }
        update(['registerPage']);
      });
    }else{
      nextRegister = false;
      update(['registerPage']);
    }
  }

  setShowPinPut(context){
    if(showPinPut){
      showPinPut = false;
      update(['registerPage']);
    }else{
      // 返回键点击事件
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pawController.dispose();
    registerEmailController.dispose();
    registerPawController.dispose();
    registerConfirmPawController.dispose();
    super.dispose();
  }
}
