import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'package:package_info/package_info.dart';
import '../globleConfig.dart';
import '../utils/comUtil.dart';
import '../utils/dataUtils.dart';
import 'upsetapp.dart';
//import '../components/down_install.dart';
import 'package:r_upgrade/r_upgrade.dart';

class UpgGradePage extends StatefulWidget {
  @override
  UpgGradePageState createState() => new UpgGradePageState();
}

class UpgGradePageState extends State<UpgGradePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _packageInfovs, _packageInfobn;
  String _newVersioncontent;
  String _conntent;
  String _deviceinfo="";
  String _copappid="";
  String _copappname=GlobalConfig.appName;

  String _downurl;
bool _updown=false;

  Future<bool> checkInfo() async {
    bool retslt = false;
//    _ipAddress = await GetIp.ipAddress;
    final packageInfo = await PackageInfo.fromPlatform();
//    _ostypename = ComFun.defaultTargetPlatform;
    _packageInfovs = packageInfo.version; //1.0.0
    _packageInfobn = packageInfo.buildNumber; //1
    _deviceinfo=await ComFun().getDeviceInfoName();
    setState(() { });

    Map<String, dynamic> response = await DataUtils.getUpgradeinfo(context);

    if (response["VERSIONNUMBER"] != null) {
      int newVersion = int.tryParse(response["VERSIONNUMBER"].toString());
      if (newVersion.compareTo(int.tryParse(packageInfo.buildNumber)) > 0) {
//            print(newVersion + "|compareTo|" + packageInfo.buildNumber);

        setState(() {
          _newVersioncontent = "($newVersion)"; //${response["update"]['ver']}
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x5FFFFFFF),
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
                  width: 0.33,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$_copappname[ID:$_copappid]??????????????????",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Divider(),
                Text(_deviceinfo),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("????????????:$_packageInfovs($_packageInfobn)"),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _newVersioncontent != null
                              ? Text("????????????:" + (_newVersioncontent ?? "??????????????????"))
                              : Text("??????????????????")),
                      Visibility(
                          visible: _conntent != null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text("?????????"),
                                Expanded(child:Text(_conntent ?? "???",
                                  softWrap: true,) )
                                ,
                              ],
                            ),
                          )),
                    ],
                  ),
                )),

                Visibility(
                    visible: _downurl != null && !_updown,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
//                      elevation: 4,
                          child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              child: Text(
                                '????????????',
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
                          onPressed: upgradeHandle
                          ),
                    )),


                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
            /*            FlatButton(
                          child: new Text("??????"),
                          onPressed: () async{

                            SharedPreferences prefs = await _prefs;
                            prefs.remove('update');
                            _prefs=null;

                            Navigator.of(context).pop(false);
                          },
                        ),*/
                        FlatButton(
                          child: new Text("??????"),
                          onPressed: () async{

                            SharedPreferences prefs = await _prefs;
                            prefs.remove('update');
                            _prefs=null;
                            Navigator.of(context).pop(true);
                          },
                        )
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      )),
    );
  }


  /*
  * ??????????????????
  * */
  upgradeHandle() async{
    if (_updown) return;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    await prefs.remove('update');
    await Clipboard.setData(ClipboardData(text: prefs.getString("ClipboardDataString")));

    _updown=true;
    _prefs=null;
    // ?????????????????????????????????????????????????????????
    if (mounted) setState(() {});
    // ??????????????????
    if (Platform.isAndroid) {
      _updateAndriod();
    } else if (Platform.isIOS) {
      launchURL();
    }
  }


  ///?????????????????????
 Future launchURL() async {
    if (await canLaunch(_downurl)) {
      await launch(_downurl);
    } else {

      setState(() {
        _conntent="????????????app????????????";
      });
    }
  }

  void _updateAndriod() async {
      Map  mockData = {
          'isForceUpdate': true,// ??????????????????
          'content': "????????????",
          'url': _downurl,// ??????????????????
        'iosurl': _downurl
        };

    await updateAlert(context, mockData);
  }

  @override
  void dispose() {
    super.dispose();
  }

}