import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../components/toproundbg.dart';
import '../../globleConfig.dart';

class ComWidget {
  /**
   * 底部左下角弧形
   */
  Widget hometopbackground(BuildContext context,{double topbgheight = 100.0,double bottomheight=100.0}) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: topbgheight,
            decoration: new BoxDecoration(
                color:KColorConstant.topbackgroundColor2,
                border: null,
                gradient: const LinearGradient(
                    colors: [KColorConstant.topbackgroundColor1, KColorConstant.topbackgroundColor2]),
//                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
//                        topRight: Radius.circular(20)
                )),
          ),
          Container(
            height: bottomheight,
            color: KColorConstant.backgroundColor,
          ),
        ],
      ),
    );

  }

  /**
   * 底部弧形
   */
  Widget homebacktopground1(BuildContext context,{double topbgheight = 150.0,double bottomheight=100.0}) {
    return   Container(
      child: Column(
        children: <Widget>[
          Container(
            height: topbgheight - 80,
            color: KColorConstant.mainColor,
          ),
          ClipPath(
            // 只裁切底部的方法
            clipper: BottonClipper(),
            child: Container(
              color: KColorConstant.mainColor,
              height: topbgheight - 100,
            ),
          ),
          Container(
            height: bottomheight,
            color: KColorConstant.backgroundColor,
          ),
        ],
      ),
    );
  }

  Widget topTitleWidget(String title) {
    final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
    return Positioned(
        top: statusBarHeight,
        left: 0,
        right: 0,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child:  Container(
              height: Klength.topBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 20,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child:  Center(
                        child: Text(title,
                          style:  KfontConstant.defaultAppbarTitleStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                ],
              ),
            )));
  }

}
