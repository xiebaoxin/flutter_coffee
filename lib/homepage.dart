import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'utils/comUtil.dart';
import 'views/myInfopage.dart';
import './globleConfig.dart';
import 'views/Indexpage.dart';
import './utils/dataUtils.dart';

class HomePage extends StatefulWidget {
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
  var tabTitles = ['首页', '菜单', '商城', '购物车', '我的']; //'灵芝鸡蛋',

  // 页面内容
  var _pages=[
    IndexPageHome(),
    MyInfoPage(),
    MyInfoPage(),
    MyInfoPage(),
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

  Widget build11(BuildContext context) {
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
                body: IndexedStack(
                  children: _pages,
                  index: _tabIndex,
                ),
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
                floatingActionButton: Container(
                  padding: EdgeInsets.all(5),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.security,color: KColorConstant.themeColor,),
                    backgroundColor: KColorConstant.greybackcolor,
                  ),
                ),
                // 设置 floatingActionButton 在底部导航栏中间
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

              ),
            )
        ));
  }

  @override
  Widget build(BuildContext context) {
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
              i+=1;
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
        /*    <Widget>[
              GestureDetector(onTap: () => _onItemTapped(0),
              child:Container(
                height: 45,width: 40,
                child: Column(
                  children: <Widget>[
                    getTabIcon(0),
                    getTabTitle(0)
                  ],
                ),
              ) ,),
              GestureDetector(onTap: () => _onItemTapped(1),
                child:Container(
                  height: 45,width: 40,
                  child: Column(
                    children: <Widget>[
                      getTabIcon(1),
                      getTabTitle(1)
                    ],
                  ),
                ) ,)
              ,
              GestureDetector(onTap: () => _onItemTapped(2),
                child:Container(
                  height: 45,width: 40,
                  child: Column(
                    children: <Widget>[
                      getTabIcon(2),
                      getTabTitle(2)
                    ],
                  ),
                ) ,),
              GestureDetector(onTap: () => _onItemTapped(3),
                child:   Container(
                  height: 45,width: 40,
                  child: Column(
                    children: <Widget>[
                      getTabIcon(3),
                      getTabTitle(3)
                    ],
                  ),
                ),)
            ],*/
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        shape: CircularNotchedRectangle(),
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

}
