import 'dart:core'; //timer
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'shopHttpUtils.dart';

class ShopDataUtils {

  static Future newmember(Map<String, dynamic> param) async{

   return await ShopHttpUtils.post("/api_v2/member/mk", param);

  }
  static Future goodsDetails(Map<String, dynamic> param) async{
    return await ShopHttpUtils.post("api_v2/mall_shop_v2/goods_details", param,withtoken: false);

  }



}
