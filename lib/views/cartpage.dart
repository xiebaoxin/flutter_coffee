import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/globle_provider.dart';
import '../model/userinfo.dart';
import 'package:flutter/cupertino.dart';
import '../globleConfig.dart';
import 'comm/comwidget.dart';
import 'cart/cart_list.dart';
import 'cart/cartbottom.dart';

class CartHomePage extends StatefulWidget {
  @override
  CartHomePageState createState() => new CartHomePageState();
}

class CartHomePageState extends State<CartHomePage>
    with SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo = Userinfo.fromJson({});

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextStyle cardtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Material(
            color: KColorConstant.backgroundColor,
            child: SafeArea(
                bottom: true,
                top: false,
                child:Scaffold (
                backgroundColor: KColorConstant.backgroundColor,
                key: _scaffoldKey,
                body:
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ComWidget().hometopbackground(context,topbgheight: 180.0,),
                          ComWidget().topTitleWidget("购物车"),
                          Positioned(
                            top: statusBarHeight+Klength.topBarHeight,
                            left: 0,
                            right: 0,
                            child:  Padding(
                              padding: const EdgeInsets.all(Klength.blankwidth),
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: KfontConstant.cardallshape,
                                child: Container(
                                  height:  MediaQuery.of(context).size.height-Klength.bottomBarHeight-200,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("商品信息"),
                                            Text("清空")
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Expanded(child: CartListWidget()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                bottomNavigationBar:  CartBottomWidget()
                )
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _strollCtrl = null;
  }
}
