import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globleConfig.dart';
import '../utils/comUtil.dart';
import '../utils/dataUtils.dart';

class UpgGradePage extends StatefulWidget {
  @override
  UpgGradePageState createState() => new UpgGradePageState();
}

class UpgGradePageState extends State<UpgGradePage> {
  String _packageInfovs, _packageInfobn;
  String _newVersioncontent;
  String _conntent;
  var _ostypename;

  String _downurl;

  Future<bool> checkInfo() async {
    bool retslt = false;
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _ostypename = ComFun.defaultTargetPlatform;
      _packageInfovs = packageInfo.version; //1.0.0
      _packageInfobn = packageInfo.buildNumber; //1
    });

   Map<String, dynamic> response=await DataUtils.getUpgradeinfo(context);

        if (response["VERSIONNUMBER"] != null) {
          int newVersion = int.tryParse(response["VERSIONNUMBER"]);
          if (newVersion.compareTo(int.tryParse(packageInfo.buildNumber)) > 0) {
//            print(newVersion + "|compareTo|" + packageInfo.buildNumber);

            setState(() {
              _newVersioncontent ="($newVersion)";//${response["update"]['ver']}
              _conntent = response["MEMO"];
              _downurl = response["URL"];

            });

            retslt = true;
          }
        }

    return retslt;
  }

  @override
  void initState() {
    checkInfo();
    super.initState();
//    initdown();
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0x5FFFFFFF),
      key: _key,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 500,
              decoration: new BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  border: new Border.all(
                    width: 0.33, )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${GlobalConfig.appName}版本信息提示",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),

                Divider(),
                Expanded(child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("当前版本:$_packageInfovs($_packageInfobn)"),
                      ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _newVersioncontent!=null
                          ? Text("有新版本:" + (_newVersioncontent ?? "已经是最新版"))
                          :Text("已经是最新版")
                  ),

                      Visibility(
                          visible: _conntent!=null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text("备注："),
                                Text(_conntent ?? "无"),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),

                Visibility(
                    visible: _downurl != null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
//                      elevation: 4,
                          child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              child: Text(
                                '升级',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'FZLanTing',
                                    fontSize: 16,
                                    color: Colors.white),
                                maxLines: 1,
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          onPressed: () {
                            launchURL(_downurl);
                          }),
                    )),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: new Text("取消"),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: new Text("确定"),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            )
                          ],
                        ),
                  ),
                )
                //Text(_loading == '0' ? "正在下载……，" : "已下载：$_loading%",style: TextStyle(color: Colors.red, fontSize: 14.0),)),
                /*           LinearProgressIndicator(
                        backgroundColor: Colors.blue,
                        value: _loading,
                        semanticsLabel: '正在下载新版本……',
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),*/
              ],
            ),
          ),
        ),
      )) ,
    );
  }

  Future launchURL(String url) async {
//    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _key.currentState.showSnackBar(SnackBar(content: Text("无法打开网址")));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
