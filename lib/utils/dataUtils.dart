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
import '../components/upgradeApp.dart';
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

  Future<bool> login(BuildContext context,String phone,String pwd,{Map<String, dynamic> wxinfo}) async {
    SharedPreferences prefs = await _prefs;
    bool loginstat=false;
    String loginurl="/api/customer/login";
    Map<String, String> params;
    if(wxinfo!=null){
      params = wxinfo;
      loginurl="/api/customer/wxlogin";
    }else{
      params = {
        "phone": phone,
        "password": pwd
      };
    }


    await HttpUtils.post(loginurl, params, context: context,withtoken: false)
        .then((response) async {
//          print(response);
      if(response!=null){

        if (response['code']==200) {
          if(wxinfo==null) {
            prefs.setString("MOBILE", phone);
            prefs.setString("PASSWORD", pwd);
          }

          loginstat= await loginserv(context,response['data']);

        }else
          await DialogUtils.showToastDialog(context, response['message']);
      }

    });
    return loginstat;
  }

 Future<bool> loginserv(context,Map<String, dynamic> logininfo) async{
   SharedPreferences prefs = await _prefs;
  bool loginstat=false;
  if(logininfo!=null && logininfo['id']>0){
    String userid=logininfo['id'].toString();

    await prefs.setString("token", logininfo['token']??"");
    await prefs.setInt("userid",int.parse(userid));

    Map<String, dynamic> userinfo= await  DataUtils().getuserinfo(context,customerId: userid);
    print(userinfo);
    final model =  Provider.of<GlobleProvider>(context);
    await model.setlogin(userinfo);

    loginstat=true;
  }

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
        if (response['code']==200)
            loginstat=true;
        else
          await DialogUtils.showToastDialog(context, response['message']);
      }

    });
    return loginstat;
  }

  Future<Map<String, dynamic>> getuserinfo(BuildContext context,{String customerId=''}) async {
    SharedPreferences prefs = await _prefs;
    Map<String, String> params = {
      "customerId":customerId.isEmpty? prefs.getInt("userid").toString():customerId
    };
    Map<String, dynamic> userinfo;

    await HttpUtils.get("/api/customer/info", params, context: context,withtoken: true)
        .then((response) async {
      if(response!=null){

        if (response['code']==200)
          userinfo=response['data'];
        else
          await DialogUtils.showToastDialog(context, response['message']);
      }

    });
    return userinfo;
  }


  Future<bool> setPayPassword(BuildContext context,String phone, String password,String verificationCode) async {
    SharedPreferences prefs = await _prefs;
    Map<String, String> params = {
//      "customerId": prefs.getInt("userid").toString(),
      "phone": phone,
      "password": password,
      "verificationCode": verificationCode
    };

    Map<String, dynamic> userinfo;

    await HttpUtils.post("/api/customer/payment-password/set", params, context: context,withtoken: true)
        .then((response) async {
      if(response!=null){
        if (response['code']==200)
         return true;
        else
          await DialogUtils.showToastDialog(context, response['message']);
      }

    });
    return false;
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


  static Future<List<Map<String, dynamic>>> getIndexTopSwipperBanners(
      BuildContext context) async {
    List<Map<String, dynamic>> AdsList = List();

    await HttpUtils.get("/api/advertise/list", {}, context: context,withtoken: false)
        .then((response) async {
      if(response!=null){

        if (response['code']==200 && response['data'] != null) {
          response['data'].forEach((ele) {
            if (ele.isNotEmpty) {
              AdsList.add(ele);
            }
          });
        }else
          await DialogUtils.showToastDialog(context, response['message']);
      }
    });

    return AdsList;
  }


  Future freshlogin(BuildContext context)async{
    SharedPreferences prefs = await _prefs;

    var phone = prefs.getString("MOBILE") ?? "";
    var pwd = prefs.getString("PASSWORD") ?? "";
    if (phone != null && phone.isNotEmpty && pwd.isNotEmpty) {
      await login(context, phone, pwd);
    }
  }




  static Future<List<Map<String, dynamic>>> getNearByDevice(
      BuildContext context,Map<String, String> params) async {
    List<Map<String, dynamic>> returnList = List();

    Map<String, dynamic> response =
    await HttpUtils.get("/api/device/nearby", params, context: context,withtoken: false);

    if (response['code']==200 && response !=null && response['data'] != null) {
      response['data'].forEach((ele) {
        if (ele.isNotEmpty) {
          returnList.add(ele);
        }
      });
    }else
      await DialogUtils.showToastDialog(context, response['message']);

    return returnList;
  }


  static Future<List<Map<String, dynamic>>> getDrinkTypeList(
      BuildContext context,int deviceId) async {
    List<Map<String, dynamic>> returnList = List();
    Map<String, String> params = {
      "deviceId": deviceId.toString()
    };
    Map<String, dynamic> response =
    await HttpUtils.get("/api/drink-type/list", params, context: context,withtoken: false);

    if (response['code']==200 && response !=null && response['data'] != null) {
      response['data'].forEach((ele) {
        if (ele.isNotEmpty) {
          returnList.add(ele);
        }
      });
    }else
      await DialogUtils.showToastDialog(context, response['message']);

    print(returnList);
    return returnList;
  }


  static Future<List<Map<String, dynamic>>> getDrinkList(
      BuildContext context,int deviceId,int drinkTypeId) async {
    List<Map<String, dynamic>> returnList = List();
    Map<String, String> params = {
      "deviceId": deviceId.toString(),
      "drinkTypeId":drinkTypeId.toString()
    };
    Map<String, dynamic> response =
    await HttpUtils.get("/api/drink/list", params, context: context,withtoken: false);

    if (response['code']==200 && response !=null && response['data'] != null) {
      response['data'].forEach((ele) {
        if (ele.isNotEmpty) {
          returnList.add(ele);
        }
      });
    }else
      await DialogUtils.showToastDialog(context, response['message']);
print(returnList);
    return returnList;
  }


  // 提交订单
  static Future addCoffeeOrder(BuildContext context,Map<String, String> params) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    params.putIfAbsent("customerId", () => prefs.getInt("userid").toString());
    print(params);
    Map<String, dynamic> response =
    await HttpUtils.post("/api/orders/orders-payment", params, context: context,withtoken: true);

    if (response['code']==200 && response !=null && response['data'] != null) {
      return response['data'];
    }else{
      await DialogUtils.showToastDialog(context, response['message']);
      return null;
    }

  }

  static Future addCoffeeOrderByyue(BuildContext context,Map<String, dynamic> params) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    params.putIfAbsent("customerId", () => prefs.getInt("userid").toString());
    print(params);
    Map<String, dynamic> response =
    await HttpUtils.post("/api/orders/orders-payment/app", params, context: context,withtoken: true);

    if (response['code']==200 && response !=null && response['data'] != null) {
      return response['data'];
    }else{
      await DialogUtils.showToastDialog(context, response['message']);
      return null;
    }

  }

  static Future<List<dynamic>> getOrderByUserIdPage(
      BuildContext context, String otype, int page,
      {int pagesize = 20}) async {

    var returnList;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> params = {
      "customerId": prefs.getInt("userid").toString(),
      "page": (page+1).toString(),
      "number": pagesize.toString(),
      "ordersType":otype
    };

    var response = await HttpUtils.get("/api/orders/my", params, context: context,withtoken: true);

    if (response['code']==200 && response !=null && response['data'] != null) {
      returnList= response['data'];
    }
    return returnList;
  }

  static Future<List<Map<String, dynamic>>> getRechargeConfig(
      BuildContext context) async {
    List<Map<String, dynamic>> returnList = List();
    Map<String, String> params = { };
    Map<String, dynamic> response =
    await HttpUtils.get("/api/customer/recharge-config", params, context: context,withtoken: false);

    if (response['code']==200 && response !=null && response['data'] != null) {
      response['data'].forEach((ele) {
        if (ele.isNotEmpty) {
          returnList.add(ele);
        }
      });
    }else
      await DialogUtils.showToastDialog(context, response['message']);
    print(returnList);
    return returnList;
  }

  static Future RechargePay(BuildContext context,int moenytype,int paytype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> params = {
    "rechargeId":moenytype.toString(),//id
    "customerId":prefs.getInt("userid").toString(),
      'type':paytype.toString()
    };

    Map<String, dynamic> response =
    await HttpUtils.post("/api/customer/recharge", params, context: context,withtoken: true);

    if (response['code']==200 && response !=null && response['data'] != null) {
      return response['data'];
    }else{
      await DialogUtils.showToastDialog(context, response['message']);
      return null;
    }

  }

  static String coffeeorderstatus(int status) {
   List<String> ordersttlist=['待付款','待取货','已通知咖啡机','已完成','已退款','全部'];
    return ordersttlist[status];
  }

  static String coffeesugarRule(int sugarRule) {
    List<String> sugarRulelist=['无糖','少糖','标准','多糖'];
    return sugarRulelist[sugarRule];
  }


  static String coffeePayType(int paytype) {
    List<String> sugarRulelist=['','微信','支付宝','云闪付','app支付'];
    return sugarRulelist[paytype];
  }


  static List<DropdownMenuItem<String>> getusertypelist() {
    List<DropdownMenuItem<String>> sortItems = [];
    sortItems.add(DropdownMenuItem(value: 'O', child: Text('业主')));
    sortItems.add(DropdownMenuItem(value: 'F', child: Text('家属')));
    sortItems.add(DropdownMenuItem(value: 'R', child: Text('租户')));
    return sortItems;
  }

  void checkUpdateApp(context) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    SharedPreferences prefs = await _prefs;
    String isupdate = prefs.getString('update') ?? ''; //暂时每次更新

    if (isupdate == '') {
      if (await checkDownloadApp(context)) {
        bool  _isupdate = await DialogUtils().showMyDialog(context, '有更新版本，是否马上更新?');
        if (!_isupdate) {
          prefs.setString("update", 'yes');
          _prefs=null;

        } else {
          prefs.remove('update');
          _prefs=null;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpgGradePage(),
            ),
          );
        }
      }
    }


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

    Map<String, String> params = {
      "TYPE": type.toString(),
    };

    Map<String, dynamic> response =
    await HttpUtils.get("appcity/getUpgrade", params, context: context);

    if (response != null)
      return response['data'];
    else
      return response;
  }

}
