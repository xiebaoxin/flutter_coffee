import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee/utils/dataUtils.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart.dart';
import 'userinfo.dart';

class GlobleProvider with ChangeNotifier {
//  GlobleModel of(context) => ScopedModel.of(context);
  String _token = '';
  bool _iosopen=true;
int _userid=0;
  int _regtype=0;
  bool _loginStatus = false;
  Userinfo _userinfo=Userinfo.fromJson({});

  int get regtype=> _regtype;
  int get userid=>_userid;
  bool get loginStatus => _loginStatus;
  String get token => _token;
  Userinfo get userinfo => _userinfo;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future setlogin(Map<String, dynamic> userinfojson) async {
    SharedPreferences prefs = await _prefs;
    _loginStatus = true;
    _token = prefs.getString("token") ?? '';
    _userid = prefs.getInt("userid") ?? 0;

    print("token :$_token-- userid: $_userid----");

    userinfojson.putIfAbsent("id",()=> _userid.toString());
    userinfojson.putIfAbsent("token",()=> _token);
    _userinfo = Userinfo.fromJson(userinfojson);

    print('正在登录到指定位置');
    notifyListeners();
  }


  Future setlogout() async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove('token');
    await prefs.remove('userid');

    await prefs.remove('MOBILE');
    await prefs.remove('PASSWORD');
    await prefs.remove("wellcomeok");

    _token = '';
    _userid = 0;
    _loginStatus = false;
    _userinfo = Userinfo.fromJson({});

    notifyListeners();
  }


  bool get iosopen=>_iosopen;

  Future getIosOpenVersion({String vs=''}) async {
    if (!kIsWeb && Platform.isIOS) {
      if (vs.isNotEmpty) {

        var packageInfo = await PackageInfo.fromPlatform();
        var parsedVs = int.tryParse(vs);
        var parsedBuild = int.tryParse(packageInfo.buildNumber);
        if (parsedVs != null && parsedBuild != null && parsedVs.compareTo(parsedBuild) == 0)
          _iosopen= false;
      }
      notifyListeners();
    }

  }


  int _cartcount = 0;
  int get cartcount => _cartcount;

  Future setcartcount(int cartcount) async {
    _cartcount = cartcount;
    notifyListeners();
  }

//-------------------------------
//以下为购物车
  List<CartItemModel> _cartitems=[];
  List<CartItemModel> get cartitems=>_cartitems;

  int get itemsCount {
    return _cartitems.length;
  }

  bool get isAllchecked {
    return _cartitems.every((i) => i.isSelected);
  }

  switchAllCheck() {
    if (this.isAllchecked) {
      _cartitems.forEach((i) => i.isSelected = false);
    } else {
      _cartitems.forEach((i) => i.isSelected = true);
    }
    notifyListeners();
  }

  double get sumTotal {
    double total = 0;
    _cartitems.forEach((item) {
      if (item.isDeleted == false && item.isSelected == true) {
        total = item.price * item.count + total;
      }
    });
    return total;
  }

  //设置当前数量
  setCount(int index,int cnt) {
    _cartitems[index].count = cnt;
    _cartitems[index].buyLimit -= cnt;
    notifyListeners();
  }

  addCount(int index) {
    _cartitems[index].count +=  1;
    notifyListeners();
  }


  downCount(int index) {
    _cartitems[index].count -= 1;
    notifyListeners();
  }

  removeItem(index) {
        _cartitems.removeAt(index);
       /* if(index==0){
          _cartitems=[];
        }else{
          _cartitems[index].count =0;
          _cartitems[index].isDeleted = true;
        }*/

        notifyListeners();

  }

  switchSelect(i) {
    _cartitems[i].isSelected = !_cartitems[i].isSelected;
    notifyListeners();

  }

  get totalCount {
    int count = 0;
    _cartitems.forEach((item) {
      if (item.isDeleted == false && item.isSelected == true) {
        count = item.count + count;
      }
    });
    return count;
  }


  void addtocart(context,Map<String, dynamic> params) {
    CartItemModel item=CartItemModel.fromJson((params));
      _cartitems.add(item);
      notifyListeners();
  }




}
