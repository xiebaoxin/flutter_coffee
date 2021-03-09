import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../globleConfig.dart';
import 'index_page.dart';

class homePage extends StatefulWidget {
  @override
  homePageState createState() => new homePageState();
}

class homePageState extends State<homePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _tabIndex = 0;

  // 正常情况的字体样式
  final tabTextStyleNormal = new TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'FZLanTing',
  );

  // 选中情况的字体样式
  final tabTextStyleSelect = new TextStyle(
    fontSize: 12,
    color: KColorConstant.mainColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'FZLanTing',
  );

  // 底部菜单栏图标数组
 var tabImages = [
    [ Icon(Icons.home),Icon(Icons.home,color: KColorConstant.mainColor) ],
    [
      [ Icon(Icons.category),Icon(Icons.category,color: KColorConstant.mainColor) ],
    ],
    [
      Icon(Icons.shopping_cart),Icon(Icons.shopping_cart,color: KColorConstant.mainColor,)
    ],
    [
      Icon(Icons.person),Icon(Icons.person,color: KColorConstant.mainColor,)
    ]
  ];

  // 菜单文案'商城','直播',
  var tabTitles = ['首页', '分类', '购物车', '我的'];

  var _pages=[
    IndexPageHome(),
    IndexPageHome(),
    IndexPageHome(),
    IndexPageHome()
//    Category(),
//    Cart(ishome: true),
//    MyInfoPage(
//      ishome: true,
//    ),
  ];


  //获取菜单栏字体样式
  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelect;
    } else {
      return tabTextStyleNormal;
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

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Material(
              color: Color(0xFFFFFFFF),
              borderOnForeground: false,
              child: Scaffold(
                body: IndexedStack(
                  children: _pages,
                  index: _tabIndex,
                ),
//          CupertinoTabBar BottomNavigationBar
                bottomNavigationBar: CupertinoTabBar(
                  items: getBottomNavigationBarItem(),
                  currentIndex: _tabIndex,
//              activeColor: GlobalConfig.mainColor,
                  iconSize: 26,
                  onTap: (index) {
                    setState(() {
                      _tabIndex = index;
                    });
                  },
                ),
              ),
//            )
        ));
  }

  /*
  void initData() async {
    final rmodel = globleModel().of(context);
    await rmodel.freshCartItem();
    await rmodel.freshOrderCounts(context);
  }*/

  @override
  void initState() {
    super.initState();
//    initData()
  }

  @override
  void dispose() {
    super.dispose();
  }

}
