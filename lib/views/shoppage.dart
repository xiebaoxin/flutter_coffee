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

class ShopHomePage extends StatefulWidget {
  @override
  MyInfoPageState createState() => new MyInfoPageState();
}

class MyInfoPageState extends State<ShopHomePage>
    with SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo = Userinfo.fromJson({});
  String _userAvatar = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextStyle cardtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  bool _logout = true;
  String _istoken = '';
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Material(
            child: Scaffold(
                backgroundColor: KColorConstant.backgroundColor,
                key: _scaffoldKey,
                body: ListView(
                    padding: EdgeInsets.all(0),
                    controller: _strollCtrl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ComWidget.hometopbackground(context,topbgheight: 180.0),
                          ComWidget.topTitleWidget("商城"),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Klength.blankwidth),
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[

                              Divider(),

                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        ),
                      )
                    ]))));
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
