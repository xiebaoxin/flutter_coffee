import 'dart:core'; //timer
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DialogUtils.dart';
import 'comUtil.dart';
import '../globleConfig.dart';

class HttpUtils {
  /// global dio object
  static Dio dio;

  /// default options
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

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// 创建 dio 实例对象 context
  static Dio createInstance() {
    String baseUrl = GlobalConfig.base;
    if (dio == null) {
      dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
//          contentType: Headers.formUrlEncodedContentType
      ));

      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        print("\n================== 请求数据 ==========================");
        print("url [${options.method}] = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
      }, onError: (DioError e) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("\n");
      }));
    }
    return dio;
  }

  static clear() {
    dio = null;
  }

  static Future get(String url, Map<String, dynamic> params,
      {BuildContext context, bool withtoken = true}) async {
    return await _request(url, params,
        context: context, method: GET, withToken: withtoken);
  }

  static Future post(String url, Map<String, dynamic> params,
      {BuildContext context, bool withtoken = true}) async {
    return await _request(url, params,
        context: context, method: POST, withToken: withtoken);
  }

  static Future _request(String url, Map<String, dynamic> params,
      {BuildContext context,
      String method = POST,
      bool withToken = true}) async {
    print("-----<net---> url :<" + method + ">" + url);
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";

    dio = createInstance();
    if (withToken == true) {
      SharedPreferences prefs = await _prefs;
      dio.options.headers = {
        'Accept': 'application/json, text/plain, */*',
        'token': prefs.getString("token"),
      };
    } else {
      dio.options.headers = {
        'Accept': 'application/json, text/plain, */*',
        'token': GlobalConfig.gtoken,
      };
    }

    List urlapi = url.split("/");
    String headerapi = urlapi.last;
    if (url.endsWith("/")) {
      int len = urlapi.length;
      headerapi = urlapi[len - 2];
    }

    if (params == null || params.isEmpty) {
      params = {};
    }

    try {
      Response response;
      if (method == GET) {
         response = await dio.get(url, queryParameters: ComFun.aesen(headerapi, params));
      }else
        {

          FormData paramformdata =
          FormData.fromMap(ComFun.aesen(headerapi, params));

           response = await dio.request(url,
              data: paramformdata, options: Options(method: method));
        }

      print(response);
      int statusCode = response.statusCode;
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(context, errorMsg);
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
//      print("dio erro:----${errorResponse.statusCode}:${errorResponse.statusMessage}");
      if (context != null) {
        if (errorResponse.statusCode == 666)
          await _handError(context, "网络请求异常,请稍后再试");
        else
          await _handError(
              context, "网络请求异常:${errorResponse.statusCode}${error.message}");
      }

      return null;
    }
  }

  //处理异常
  static Future _handError(BuildContext context, String errorMsg) async {
//    print("<net> errorMsg :" + errorMsg);
    await DialogUtils.showToastDialog(context, errorMsg);
  }
}
