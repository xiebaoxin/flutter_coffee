import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coffee/model/carts_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './model/globle_provider.dart';
import 'homepage.dart';
import 'globleConfig.dart';
import 'wellcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GlobleProvider>(
        create: (context) => GlobleProvider(),
      ),
      ChangeNotifierProvider<CartsProvider>(
        create: (context) => CartsProvider(),
      ),
    ],
    child: initApp(),
  ));
//  runApp(MyApp(model: GlobleModel()));

}

////flutter packages pub run flutter_launcher_icons:main  --一键生成logo


class initApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return MaterialApp(
        title: GlobalConfig.appName,
        navigatorKey: Constants.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        initialRoute: "/wellcome",
        onGenerateTitle: (context) {
          return GlobalConfig.appName;
        },

        theme: ThemeData(
          brightness: Brightness.light,
          /*
     * primarySwatch是主题颜色的一个样本。通过这个样本可以在一些条件下生成一些其他的属性。
     * 例如，若没有指定primaryColor，并且当前主题不是深色主题，那么primaryColor就会默认为primarySwatch指定的颜色，
     * 还有一些相似的属性：accentColor、indicatorColor等也会受到primarySwatch的影响。
        accentColor - Color类型，前景色(按钮、文本、覆盖边缘效果等)
        */
          //用于导航栏、FloatingActionButton的背景色等
//            primarySwatch:Colors.blueGrey,
//            primaryColor  App主要部分的背景色（ToolBar,Tabbar等）
          primaryColor: KColorConstant.mainColor,
          primaryIconTheme:
          const IconThemeData(color: KColorConstant.themeColor),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),

          iconTheme:
          IconThemeData(color: KColorConstant.mainColor), //用于Icon颜色

          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: KColorConstant.mainColor,
//              highlightColor: Colors.greenAccent
          ),
        ),

//          WellCome() // SplashPage(),alipaytest(),//
    );
  }
}

