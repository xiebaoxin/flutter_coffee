import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/globle_provider.dart';
import '../model/userinfo.dart';
import 'package:flutter/cupertino.dart';
import '../components/upgradeApp.dart';


class MyInfoPage extends StatefulWidget {
  @override
  MyInfoPageState createState() => new MyInfoPageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class MyInfoPageState extends State<MyInfoPage>
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
            backgroundColor: Color(0xFFFFFFFF),
            key: _scaffoldKey,
            body: Center(child: Text("hehe"))))
  );

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
