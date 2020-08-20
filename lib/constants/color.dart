import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class KColorConstant {
//  顶部
  static final Color mainColor =Color(0xFFFD8513);//Color(0xffde7b1d);//Color.fromRGBO(255, 140, 34, 1);//Color(0xFFff9933);//Colors.deepOrange;

  static const Color themeColor = Color.fromRGBO(255, 140, 71, 0.95);// Color.fromRGBO(132, 95, 63, 1.0);
  //页面背景
  static const Color backgroundColor=Color(0xffF9FAFA);


  static final Color greybackcolor= Color(0xFFeeeeee);

  static const Color txtFontColor =Color.fromRGBO(144,144,144,0.8);//Color(0xFF2f2f2f);
  static const Color tabtxtColor = Color.fromRGBO(88, 88, 88, 0.9);


  static const Color bottomIconBgColor = Color.fromRGBO(88, 88, 88, 0.5);
  static const Color floorTitleColor = Color.fromRGBO(51, 51, 51, 1);

  static const Color categoryDefaultColor = Color(0xFF888888);
  static const Color priceColor =Color.fromRGBO(245, 90, 22, 0.9);// Color.fromRGBO(182, 9, 9, 1.0);// themeColor;//;

  // 加减器
  static const Color cartDisableColor = Color.fromRGBO(221, 221,221,1.0);
  static const Color cartItemChangenumBtColor = Color(0xFFFD8513);

  //  首页顶部渐变色
  static const Color topbackgroundColor1=Color(0xffFF8918);
  static const Color topbackgroundColor2=Color(0xffFF6919);
  //渐变色调
  static const BoxDecoration boxdecrationline =  BoxDecoration(
  color: topbackgroundColor2,
  border: null,
  gradient:
  const LinearGradient(colors: [topbackgroundColor1, topbackgroundColor2]),
  );

}