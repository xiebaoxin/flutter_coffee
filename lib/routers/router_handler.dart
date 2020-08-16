import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../views/login.dart';
import '../views/myInfopage.dart';
import '../homepage.dart';
import '../wellcome.dart';
import '../components/webView.dart';

/*
Handler detailsHandle = Handler(
  handlerFunc: (BuildContext context , Map<String , List<String>> params){
    String goodsId = params['goodsId'].first;
    return DetailsPage(goodsId: goodsId,);
  },
);
*/

// /web?url=${Uri.encodeComponent(linkUrl)}&title=${Uri.encodeComponent('掘金沸点')}
//'/swip?pics=${Uri.encodeComponent(_buildPicsStr())}&currentIndex=${i.toString()}'
Handler webPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String articleUrl = params['url']?.first;
      String title = params['title']?.first;
      print('$articleUrl and  $title');
      return WebViewNew(title, articleUrl);
    }
);


Handler loginPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginPage();
    });


Handler wellcomePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return WellCome();
    });

Handler homePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return HomePage();
    });



Handler userPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MyInfoPage();//MyInfoPage()user_id,status,phone,name,avatar
    });

