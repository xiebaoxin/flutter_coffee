import 'dart:core'; //timer
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DialogUtils.dart';
import 'utils.dart';
import 'comUtil.dart';
import '../globleConfig.dart';

class ShopHttpUtils {
  /// global dio object
  static const int CONNECT_TIMEOUT = 50000;
  static const int RECEIVE_TIMEOUT = 30000;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  /// http request methods
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';

  static Dio dio2;

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// 创建 dio 实例对象 context
  static Dio createInstance() {
    if (dio2 == null) {
      dio2 = Dio(BaseOptions(
        baseUrl: GlobalConfig.shopBaseServer,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      ));
//      dio2.options.headers = {
//        'Accept': 'application/json, text/plain, */*',
//      };
       dio2.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        print("\n================== 请求2数据 ==========================");
        print("url [${options.method}] = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
      }, onError: (DioError e) {
        print("\n================== 错误2响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("\n");
      }));
    }
    return dio2;
  }

  static clear() {
    dio2 = null;
  }

  static Map<String, dynamic> signParam(Map<String, dynamic> params) {
    Map<String, dynamic> treeMap = params;

    String enstr = "";
    sortaz(params).forEach((k, v) {
      if (v.toString().isNotEmpty) {
        enstr += "&$k=$v";
      }
    });
    enstr = enstr.replaceFirst("&", "");
    enstr += GlobalConfig.shopAppsecret;
print(enstr);
    String signstr = ComFun.md5me(enstr).toUpperCase();
    treeMap.putIfAbsent("sign", () => signstr);
    print(treeMap);
    return treeMap;
  }

  static Future upload(String url, FormData formData,
      {Function onSendProgressCallBack, BuildContext context}) async {
    dio2 = createInstance();

    Response response =
        await dio2.post(url, data: formData, onSendProgress: (received, total) {
      onSendProgressCallBack(received, total);
    });

    return response.data;
  }

  static Future get(String url, Map<String, dynamic> params,
      { bool withtoken = true}) async {
    return await _request(url, params,method: GET, withToken: withtoken);
  }

  static Future post(String url, Map<String, dynamic> params,{
       bool withtoken = true}) async {
    return await _request(url, params, method: POST, withToken: withtoken);
  }

  static Future _request(String url, Map<String, dynamic> params,
      {
      String method = POST,
      bool withToken = true}) async {
    print("-----<net---> url :<" + method + ">" + url);
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";

    if (params == null || params.isEmpty) {
      params = {};
    }
    params.putIfAbsent("appid", () => GlobalConfig.shopAppId);
    dio2 = createInstance();
    if (withToken == true) {
      SharedPreferences prefs = await _prefs;
      params.putIfAbsent(
          "member_openid", () => prefs.getString("shop_member_openid") ?? "");
    }
    params=signParam(params);
    try {
      Response response;
      if (method == GET) {
        response = await dio2.get(url, queryParameters: params);
      } else {
        FormData paramformdata = FormData.fromMap(params);
        response = await dio2.request(url,
            data: paramformdata, options: Options(method: method));
      }

      print(response);
      int statusCode = response.statusCode;
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorMsg);
      }
      return response.data;
    } on DioError catch (error) {
      // 请求错误处理
      Response errorResponse;

      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }

        if (errorResponse.statusCode == 666)
          await _handError("网络请求异常,请稍后再试");
        else
          await _handError( "网络请求异常:${errorResponse.statusCode}${error.message}");

      return null;
    }
  }

  //处理异常
  static Future _handError( String errorMsg) async {
    await DialogUtils.showToastDialog(G.getCurrentContext(), errorMsg);
  }
}
