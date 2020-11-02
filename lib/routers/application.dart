import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:fluro/fluro.dart';
import '../utils/DialogUtils.dart';
import '../model/globle_provider.dart';
import 'package:provider/provider.dart';
import '../views/comm/goods_detail/index.dart';

class Application {
//  static  FluroRouter router;
  static Router router;
  static void goto(context, appuri,
      {String url, String title, bool withToken = false}) async {
    if (appuri.startsWith('/web')) {
      if (url != '') {
        await webto(context, appuri,
            title: title, url: url, withtoken: withToken);
      } else {
        await DialogUtils.showToastDialog(context, '无效网址');
      }
    } else {
      /*   var transition = (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return new ScaleTransition(
          scale: animation,
          child: new RotationTransition(
            turns: animation,
            child: child,
          ),
        );
      };
      return Application.router.navigateTo(
          context,appuri,
          transition: TransitionType.custom, /// 指定是自定义动画
          transitionBuilder: transition, /// 自定义的动画
          transitionDuration: const Duration(milliseconds: 600)); /// 时间*/

      router.navigateTo(context, appuri, transition: TransitionType.fadeIn);
    }
  }

  static Future webto(context, appuri,
      {String url, String title, bool withtoken}) async {
    if (appuri.startsWith('/web')) {
      appuri =
          "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title ?? '信息浏览')}";
      await router.navigateTo(context, appuri,
          transition: TransitionType.fadeIn);
    } else {
      await DialogUtils.showToastDialog(context, '无效网址');
    }
  }

  Future checklogin(BuildContext context, Function callBack) async {
    final model =  Provider.of<GlobleProvider>(context);
    if (model.loginStatus) {
      callBack();
    } else {
//      await Navigator.pushNamed(context, '/login',)
      await router
          .navigateTo(context, "/login", transition: TransitionType.fadeIn)
          .then((v) {
        if (v != null && v == true && callBack != null) callBack();
      });
    }
  }

static coffeeDetail(context,Map<String, dynamic> coffee,Map<String, dynamic> machine){
   return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CoffeeDetailDialog(
            coffee: coffee,
mach: machine,
          );
        }
    );

}

  ///跳转到
  static goodsDetail(context, int goodsId,
      {Map<String, dynamic> goodsinfo,
      String shoptype = "W",
      Map<String, dynamic> shop,
      bool shopown = false}) {
    if (shoptype == "W") {
     /* Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              DetailsPage(goodsId: goodsId, goodsinfo: goodsinfo),
        ),
      );*/
    }
  }

/*
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
//          return Detail('45');
        return WebView('45', 'http://www.baidu.com');
        },
        transitionsBuilder:
            (___, Animation<double> animation, ____, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        })
    );
*/

}
