import './router_handler.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String root = '/';
  static String loginPage = '/login';
  static String houserenzhPage = '/houserenzh';
  static String houselistPage = '/houselist';
  static String wellcomePage = '/wellcome';
//  static String loginPage = '/shequ';
  static String webViewPage = '/web';
  static String homePage = '/home';
  static String userCenterPage = '/user';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return ;
    });
    router.define(root,handler: homePageHandler);

    router.define(wellcomePage,handler: wellcomePageHandler);
    router.define(webViewPage, handler: webPageHandler);
    router.define(homePage, handler: homePageHandler);
    router.define(loginPage,handler: loginPageHandler);
    router.define(userCenterPage, handler:userPageHandler);

  }
}
