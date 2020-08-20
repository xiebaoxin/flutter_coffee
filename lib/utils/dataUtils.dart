import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import '../utils/HttpUtils.dart';
import '../utils/comUtil.dart';
import '../utils/DialogUtils.dart';
import '../model/globle_provider.dart';
import 'comUtil.dart';

class DataUtils {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> captcha(BuildContext context,String phone) async {
    bool loginstat=false;

    Map<String, String> params = {
      "phone": phone
    };

    var response= await HttpUtils.post("/api/captcha/", params, context: context,withtoken: false);
    print(response);
    if(response!=null){
      await DialogUtils.showToastDialog(context, response['message']);
      if (response['code']==200) {

        loginstat=true;
      }
    }

    return loginstat;
  }


  Future<bool> register(BuildContext context,String phone,String pwd,String smscode) async {
    bool loginstat=false;
    Map<String, String> params = {
      "phone": phone,
      "password": pwd,
      "type":Platform.isIOS?"2":"1",
      "regType": "1",
      "verificationCode":smscode
    };

    print(params);
   var response= await HttpUtils.post("/api/customer/register", params, context: context,withtoken: false);
          print(response);
      if(response!=null){
        await DialogUtils.showToastDialog(context, response['message']);
        if (response['code']==200) {

          loginstat=true;
          }
        }

    return loginstat;
  }

  Future<bool> login(BuildContext context,String phone,String pwd) async {
    SharedPreferences prefs = await _prefs;
    bool loginstat=false;
    Map<String, String> params = {
      "phone": phone,
      "password": pwd
    };

    await HttpUtils.post("/api/customer/login", params, context: context,withtoken: false)
        .then((response) async {
//          print(response);
      if(response!=null){
        await DialogUtils.showToastDialog(context, response['message']);
        if (response['code']==200) {

            prefs.setString( "MOBILE", phone);
            prefs.setString( "PASSWORD", pwd);

            String userid=response['data']['id'].toString();

            await prefs.setString("token", response['data']['token']??"");
            await prefs.setInt("userid",int.parse(userid));

            Map<String, dynamic> userinfo= await  DataUtils().getuserinfo(context, userid);
            print(userinfo);
            final model =  Provider.of<GlobleProvider>(context);
            await model.setlogin(userinfo);

          loginstat=true;
        }
      }

    });
    return loginstat;
  }


  Future<bool> logout(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    bool loginstat=false;
    Map<String, String> params = {
      "customerId": prefs.getInt("userid").toString()
    };

    await HttpUtils.post("/api/customer/logout", params, context: context)
        .then((response) async {
      if(response!=null){
        await DialogUtils.showToastDialog(context, response['message']);
        if (response['code']==200)
            loginstat=true;
      }

    });
    return loginstat;
  }

  Future<Map<String, dynamic>> getuserinfo(BuildContext context,String customerId) async {
    SharedPreferences prefs = await _prefs;
    Map<String, String> params = {
      "customerId": prefs.getInt("userid").toString()
    };
    Map<String, dynamic> userinfo;

    await HttpUtils.get("/api/customer/info", params, context: context,withtoken: true)
        .then((response) async {
      if(response!=null){
        await DialogUtils.showToastDialog(context, response['message']);
        if (response['code']==200)
          userinfo=response['data'];
      }

    });
    return userinfo;
  }


  static Future<List<Map<String, dynamic>>> startuppage(
      BuildContext context) async {
     List<Map<String, dynamic>> returnList = List();
    Map<String, String> params = {};

    Map<String, dynamic> response =
    await HttpUtils.get("/back/startup-page/list", params, context: context);
    if (response['data'] != null) {
      response['data'].forEach((ele) {
        if (ele.isNotEmpty) {
          returnList.add(ele);
        }
      });
    }
    return returnList;
  }

  Future<String>  getDeviceInfoName() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
//      print('IOS设备：');
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.name},${iosInfo.systemVersion}";
    }else if(Platform.isAndroid){
//      print('Android设备');
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.brand},${androidInfo.model},${androidInfo.version.release}";
    }
  }

  Future freshlogin(BuildContext context)async{
    SharedPreferences prefs = await _prefs;

    var phone = prefs.getString("MOBILE") ?? "";
    var pwd = prefs.getString("PASSWORD") ?? "";
    if (phone != null && phone.isNotEmpty && pwd.isNotEmpty) {
      await login(context, phone, pwd);
    }
  }

  static List<DropdownMenuItem<String>> getusertypelist() {
    List<DropdownMenuItem<String>> sortItems = [];
    sortItems.add(DropdownMenuItem(value: 'O', child: Text('业主')));
    sortItems.add(DropdownMenuItem(value: 'F', child: Text('家属')));
    sortItems.add(DropdownMenuItem(value: 'R', child: Text('租户')));
    return sortItems;
  }

  static Future<List<Map<String, dynamic>>> getIndexTopSwipperBanners(
      BuildContext context,
      {String oprid = "1",String covers="A"}) async {
    List<Map<String, dynamic>> AdsList = List();
    String timestap = ComFun.timestamp;
    Map<String, String> params = {
      "TIMESTAMP": timestap,
      "OPERID": oprid,
      "COVERS": covers,
    };

    await HttpUtils.get("owner/getAdByPosition?", params, context: context)
        .then((response) async {
      if (response != null) {
        if (response['data'] != null) {
          response['data'].forEach((ele) {
            if (ele.isNotEmpty) {
              AdsList.add(ele);
            }
          });
        }
      }
    });

    return AdsList;
  }

  static String houseusertype(String type) {
    String ustypename = "业主";

    switch (type) {
      case 'O':
        ustypename = "业主:";
        break;
      case "F":
        ustypename = "家属:";
        break;
      case "R":
        ustypename = "租户:";
        break;
      default:
        ;
    }
    return ustypename;
  }



  static Future openthedoor(BuildContext context,
      String lockid, String lockmac) async {


    final tkmodel =  Provider.of<GlobleProvider>(context);
    String timestap = ComFun.timestamp;
    Map<String, String> params = {
      "TIMESTAMP": timestap,
      "USERID": tkmodel.token,
      "LOCKID": lockid,
    };

    await HttpUtils.post("/owner/openDoorByMobile", params, context: context)
        .then((response) async {
      if (response['code'] == 200) {
        await DialogUtils.showToastDialog(context, '开门成功');
      }
      await DialogUtils.showToastDialog(context, response['message']);
    });
  }


  //具体的还是要看返回数据的基本结构
  Future<bool> checkDownloadApp(BuildContext context) async {
    print("<net---> checkDownloadApp :");
    bool isupdate = false;

    Map<String, dynamic> response = await getUpgradeinfo(context);
//    print(response);
    if (response != null) {
      int newVersion = int.tryParse(response["VERSIONNUMBER"]);
      // 获取此时版本
      final packageInfo = await PackageInfo.fromPlatform();
      /*    print(packageInfo.version); //1.0.0
          print(packageInfo.packageName);
          print(packageInfo.buildNumber); //1
          print(packageInfo.appName);*/
      /*      print(defaultTargetPlatform);*/
//          await SimplePermissions.requestPermission(  Permission.WriteExternalStorage);

//          if (await SimplePermissions.checkPermission(Permission.WriteExternalStorage)) {
      if (await ComFun().checkPermission()) {
        if (newVersion.compareTo(int.tryParse(packageInfo.buildNumber)) > 0) {
          isupdate = true;
        }
      } else {
        await DialogUtils.showToastDialog(context, "请打开相关权限");
        print('权限不容许');
      }
    }

    return isupdate;
  }

  static Future<Map<String, dynamic>> getUpgradeinfo(
      BuildContext context) async {
    TargetPlatform result = ComFun.defaultTargetPlatform;
    int type = 0;
    if (result == TargetPlatform.android) {
      type = 3;
    } else if (result == TargetPlatform.iOS) {
      type = 4;
    }

    String timestap = ComFun.timestamp;
    Map<String, String> params = {
      "TIMESTAMP": timestap,
      "TYPE": type.toString(),
    };

    Map<String, dynamic> response =
        await HttpUtils.get("appcity/getUpgrade", params, context: context);

    if (response != null)
      return response['data'];
    else
      return response;
  }


  // 业主提交订单
  static Future addOrder(BuildContext context,String Shopid,List<Map<String, String>> aparams,Map<String, String>mparams) async {

    Map<String, String> oparams = {
      "SHOPID":Shopid.toString(),
      "TOTALVAL":mparams['TOTALVAL'],
      "TOTALNUM":mparams['TOTALNUM'],
      "CUSTOMNAME":mparams['CUSTOMNAME'],
      "CUSTOMPHONE":mparams['CUSTOMPHONE'],
      "REMARKS":mparams['REMARKS'],
      "DELIVERYTIME":"",
      "ARRIVALTIME":''
    };
    Map<String,dynamic> params = {
      "DATA":json.encode({
        "master":oparams,//convert.jsonEncode(oparams),
        "detail":aparams,
      })

    };

    var response= await HttpUtils.post("/oto/addOrder", params, context: context);
    return response;
  }


}
