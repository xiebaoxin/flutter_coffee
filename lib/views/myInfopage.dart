import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'comm/comwidget.dart';
import '../utils/DialogUtils.dart';
import '../model/globle_provider.dart';
import '../model/userinfo.dart';
import 'package:flutter/cupertino.dart';
import '../globleConfig.dart';
import '../utils/alioss/aliossapi.dart';
import '../components/upgradeApp.dart';

class MyInfoPage extends StatefulWidget {
  @override
  MyInfoPageState createState() => new MyInfoPageState();
}

class MyInfoPageState extends State<MyInfoPage>
    with SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;


  final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
final double userwidgetheight=65.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo = Userinfo.fromJson({});
  String _userAvatar = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextStyle cardtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  bool _logout = true;
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
                          ComWidget()
                              .hometopbackground(context, topbgheight: 180.0,bottomheight: 110),
                          ComWidget().topTitleWidget("个人中心"),
                          userInfoWidget(),
                          userMoneyWidget()
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Klength.blankwidth),
                        child: Card(
                          shape: KfontConstant.cardallshape,
                          elevation: 5,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              optionItem("我的收藏", "images/icon_03.png", () {
                                ;
                              }),
                              Divider(),
                              optionItem("我的订单", "images/icon_04.png", () {
                                ;
                              }),
                              Divider(),
                              optionItem("我的积分", "images/icon_01.png", () {
                                ;
                              }),
                              Divider(),
                              optionItem("关于我们", "images/icon_06.png", () {
                                ;
                              }),
                              Divider(),
                              optionItem("投诉建议", "images/icon_07.png", () {
                                ;
                              }),
                              Divider(),
                              optionItem("咖啡机操作说", "images/icon_08.png", () {
                                ;
                              }),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        ),
                      )
                    ]))));
  }

  Widget userInfoWidget() {
    return Positioned(
        top: statusBarHeight+Klength.topBarHeight,
        left: 0,
        right: 0,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Consumer<GlobleProvider>(
                builder: (context, GlobleProvider provider, _) => Container(
                      height: userwidgetheight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: GestureDetector(
                              onTap: _openImage,
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    provider.userinfo.avtar.isNotEmpty
                                        ? NetworkImage(provider.userinfo.avtar)
                                        : AssetImage('images/logo-no.png'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    provider.userinfo.name ?? "name",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "个人资料[${provider.userinfo.phone}]",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Container(
                                  decoration: new BoxDecoration(
                                    color: Color(0xffFEFFFF),
                                    borderRadius:
//                              const BorderRadius.all(Radius.circular(20)),
                                        const BorderRadius.horizontal(
                                            left: Radius.circular(20)),
                                    border: null,
                                  ),
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5.0),
                                          child: SizedBox(
                                              height: 38,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("我的积分",style: TextStyle(color: KColorConstant.mainColor),),
                                                    Text("98",style: TextStyle(color: KColorConstant.mainColor,fontSize: KfontConstant.title16,fontWeight:FontWeight.bold),),
                                                  ],
                                                ),
                                              ))))))
                        ],
                      ),
                    ))));
  }

  Widget userMoneyWidget() {
    return Positioned(
        top: statusBarHeight+Klength.topBarHeight+userwidgetheight+5,
        left: Klength.blankwidth,
        right: Klength.blankwidth,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Consumer<GlobleProvider>(
                builder: (context, GlobleProvider provider, _) =>
                    Card(
                    shape: KfontConstant.cardallshape,
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      height: 120,
                      child: Center(
                        child: Container(
                          height: 90,
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  Container(
                                  padding: EdgeInsets.all(5),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFDF7EB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Center(
                                        child: Image.asset(
                                          "images/icon_01.png",
                                          width: 28,
                                          height: 28,
                                        ),
                                      ),
                                    )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: Text("¥",style: TextStyle(fontSize: KfontConstant.title14,color: KColorConstant.mainColor),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: Text("380.0",style: TextStyle(fontSize: 22,
                                                        color: KColorConstant.mainColor,fontWeight: FontWeight.bold),),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Text("账户余额",style: TextStyle(fontSize: KfontConstant.title14),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Container(width: 1,height:80,color: KColorConstant.greybackcolor,),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFDF7EB),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Center(
                                              child: Image.asset(
                                                "images/icon_02.png",
                                                width: 28,
                                                height: 28,
                                              ),
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: Text("3",style: TextStyle(fontSize: 22,
                                                        color: KColorConstant.mainColor,fontWeight: FontWeight.bold),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: Text("张",style: TextStyle(fontSize: KfontConstant.title14,color: KColorConstant.mainColor),),
                                                  ),

                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Text("优惠劵",style: TextStyle(fontSize: KfontConstant.title14),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )))));
  }

  Widget optionItem(String title, String img, Function callback) {
    return ListTile(
      leading: Image.asset(
        img,
        width: 28,
        height: 28,
      ),
      title: Text(
        title,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.grey,
      ),
      onTap: callback,
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

  final picker = ImagePicker();
  Future<void> _openImage() async {
    final pickedFile = await picker.getImage(
        source: await DialogUtils().showSelectImageType(context)
            ? ImageSource.camera
            : ImageSource.gallery);
    ;

    if (pickedFile != null) {
      File file = File(pickedFile.path);
    }
  }

  bool _uploadimging = false;
  void uploadimg(File f) async {
    final tempDir = await getTemporaryDirectory();

    setState(() {
      _uploadimging = true;
    });
    try {
      String retimgsstr = "";

      String path = f.path;
//      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
//
      CompressObject compressObject = CompressObject(
        imageFile: f, //image
        path: tempDir.path, //compress to path
        quality: 85, //first compress quality, default 80
        step: 9, //The bigger the fast, Smaller is more accurate, default 6
        mode: CompressMode.LARGE2SMALL, //default AUTO
      );

      await Luban.compressImage(compressObject).then((path) async {
//            var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//             await _upimglist.add(MultipartFile.fromFile(path));

        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        var newDate = DateTime.now(); //app-
        String limgname = "COFFEE-";
        String alipic = limgname +
            newDate.millisecondsSinceEpoch.toString() +
            name.substring(name.indexOf("."));
        await AliOssApiService.uploadImage(context, alipic, path,
                onSendProgressCallBack: showProgress)
            .then((data) async {
          retimgsstr += alipic + ",";
          if (data != null) {
//
//              savetodb(retimgsstr);
//              hideLoadingDialog();
          }
        });
      });
    } catch (e) {
      DialogUtils.showToastDialog(context, '提交出现异常，请稍后再试');
      return;
    }
    setState(() {
      _uploadimging = false;
    });
  }

  double _persent = 0.0;
  void showProgress(received, total) {
    if (total != -1) {
      setState(() {
        _persent =
            double.tryParse((received / total * 100).toStringAsFixed(0)) / 100;
      });
//      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
