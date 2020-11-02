import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/toproundbg.dart';
import '../../globleConfig.dart';
import '../../homepage.dart';
import '../../utils/DialogUtils.dart';

class ComWidget {
  /**
   * 底部左下角弧形
   */
  static Widget hometopbackground(BuildContext context,{double topbgheight = 100.0,double bottomheight=100.0}) {
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
  static Widget homebacktopground1(BuildContext context,{double topbgheight = 150.0,double bottomheight=100.0}) {
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

  static Widget topTitleWidget(String title) {
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


  static Widget machineitem(Map<String, dynamic> machine) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 0),
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              machine.isEmpty?
                  Container(
                    height: 100,
                    child:Text("附近5km没有找到营业的咖啡机。")
                  )
              :ListTile(
                  title: Text("${machine['name']}(NO.${machine['serialNumber']})",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                  subtitle: Text.rich(
                    TextSpan(
                      text: '[${machine['distance']*0.001}km]',
                      style: TextStyle(
                        fontSize: KfontConstant.title12,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${machine['address']}',
                            style: TextStyle(fontSize: KfontConstant.title12)),
                        TextSpan(
                            text: '\t\n ${machine['status']==0?'打烊':'正常营业'}',
                            style: TextStyle(fontSize: KfontConstant.title12, color: KColorConstant.mainColor)),
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                /*   Container(
              width: 55,
              child: Row(
                children: <Widget>[
                  Text("去看看",style: TextStyle(fontSize: 10),),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),*/
                onTap: ()async{
                  if(machine['status']==0){
                  await await DialogUtils.showToastDialog(Constants.navigatorKey.currentContext, '打烊补货，稍后再试！');
                  }else{
                    SharedPreferences prefs =await SharedPreferences.getInstance();
                    await prefs.setString("machine", jsonEncode(machine));
                    Navigator.pushReplacement(Constants.navigatorKey.currentContext, MaterialPageRoute(
                      builder: (context) => HomePage(tabindex:1,),//CartsBuyPage(),
                    ));
                  }

                },
              ),
              /*   Column(
            children: <Widget>[
              SizedBox(height: 40,),
            ],
          ),*/
            )),
      ),
    );
  }
}
