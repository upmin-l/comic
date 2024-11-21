import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required this.controller,
    required this.obscure,
    required this.textInputType,
    required this.text,
    required this.icon,
    this.validator,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final String text;
  final bool obscure;
  final IconData icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)
          ]),
      padding: const EdgeInsets.only(left: 5.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: textInputType,
        cursorColor: AppColor.defaultColor,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@#$%^&*.()]')), // 允许数字和特殊符号
        ],
        decoration: InputDecoration(
          icon: Icon(icon),
          // prefixIcon: Icon(icon),
          hintText: text,
          hintStyle: TextStyle(
            color: AppColor.gray,
            fontSize: 12.sp,
            textBaseline: TextBaseline.alphabetic,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        validator: validator,
      ),
    );
  }
}
