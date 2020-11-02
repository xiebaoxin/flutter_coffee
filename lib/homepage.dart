import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'utils/comUtil.dart';
import 'views/myInfopage.dart';
import './globleConfig.dart';
import 'views/Indexpage.dart';
import 'views/shoppage.dart';
import 'views/categorypage.dart';
import 'views/cartpage.dart';
import 'views/showmap.dart';
import './utils/dataUtils.dart';

class HomePage extends StatefulWidget {
  final int tabindex;
  HomePage({this.tabindex=0});
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  AppLifecycleState appLifecycleState;
  int _tabIndex = 0;

  // 底部菜单栏图标数组
  var tabImages=  [
    [
      /* getTabImage('images/home-no.png'),
            getTabImage('images/home.png')*/
      Icon(Icons.home,color: KColorConstant.bottomIconBgColor,),Icon(Icons.home,color: KColorConstant.mainColor,)
    ],
    [

      Icon(Icons.local_cafe,color: KColorConstant.bottomIconBgColor),
      Icon(Icons.local_cafe,color: KColorConstant.themeColor,)
    ],
    [

      Icon(Icons.store,color: KColorConstant.bottomIconBgColor,),
      Icon(Icons.store,color: KColorConstant.themeColor,)
    ],
    [

      Icon(Icons.shopping_cart,color: KColorConstant.bottomIconBgColor),
      Icon(Icons.shopping_cart,color: KColorConstant.themeColor,)
    ],
    [
      Icon(Icons.person,color: KColorConstant.bottomIconBgColor),
      Icon(Icons.person,color: KColorConstant.themeColor,)
    ]
  ];

  // 菜单文案'商城','直播',
  var tabTitles = ['首页', '菜单', '附近', '购物车', '我的']; //'灵芝鸡蛋',

  // 页面内容
  var _pages=[
    IndexPageHome(),
    CategoryHome(),
    ShowMapScreen(),
//    ShopHomePage(),
    CartHomePage(),
    MyInfoPage(),
  ];

  //获取菜单栏字体样式
  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return KfontConstant.littleselectedStyle;
    } else {
      return KfontConstant.littleStyle;
    }
  }

  // 获取图标
  Widget getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  // 获取标题文本
  Text getTabTitle(int curIndex) {
    return new Text(
      tabTitles[curIndex],
      style: getTabTextStyle(curIndex),
    );
  }

  // 生成image组件
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  // 获取BottomNavigationBarItem
  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> list = new List();
    for (int i = 0; i < _pages.length; i++) {
      list.add(new BottomNavigationBarItem(
          icon: getTabIcon(i), title: getTabTitle(i)));
    }
    return list;
  }


  void _onItemTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async{
         return await ComFun().doubleExit(context);
        },
        child:
        AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,////白色
            child: Material(
//              color: Color(0xFFFFFFFF),
              borderOnForeground: false,
              child: Scaffold(
                body: _pages[_tabIndex],
                bottomNavigationBar: CupertinoTabBar(

                  items: getBottomNavigationBarItem(),
                  currentIndex: _tabIndex,
//              activeColor: KColorConstant.mainColor,
                  iconSize: 26,
                  onTap: (index) {
                    setState(() {
                      _tabIndex = index;
                    });
                  },
                ),
              ),
            )
        ));
  }

  @override
  Widget buildqq(BuildContext context) {
    int i=-1;
    super.build(context);
    return  WillPopScope(
        onWillPop: () async{
      return await ComFun().doubleExit(context);
    },
    child:Scaffold(
      body: _pages[_tabIndex],
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: Row(
            children:
            _pages.map((it) {
              i++;
              return  GestureDetector(onTap: () => _onItemTapped(i),
                child:Container(
                  height: 45,width: 40,
                  child: Column(
                    children: <Widget>[
                      getTabIcon(i),
                      getTabTitle(i)
                    ],
                  ),
                ) ,);
            }).toList(),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
//        shape: CircularNotchedRectangle(),
      ),

    ));
  }

  Future checkappdot() async{
    if(await FlutterAppBadger.isAppBadgeSupported()){
      //    FlutterAppBadger.updateBadgeCount(1);
      FlutterAppBadger.removeBadge();//清除小红点
    }
  }
  @override
  void initState() {
    _tabIndex=widget.tabindex;
    _getinitdata();
    checkappdot();
    super.initState();
//    if (mounted) {
      print("===homepage freshlogin ====");
      DataUtils().freshlogin(context);
//    }

  }



  @override
  void dispose() {
    super.dispose();
  }


  Future _getinitdata() async {
    await AmapCore.init(GlobalConfig.aMapIosAppId);
    await AmapService.instance.init(
      iosKey: GlobalConfig.aMapIosAppId,
      androidKey: GlobalConfig.aMapAppId,
    );

  }

}
