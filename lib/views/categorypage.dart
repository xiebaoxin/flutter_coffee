import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/banner.dart';
import 'comm/comwidget.dart';
import '../utils/dataUtils.dart';
import '../components/in_text_dot.dart';
import '../utils/utils.dart';
import '../constants/config.dart';
import '../globleConfig.dart';
import '../utils/DialogUtils.dart';
import '../components/banner.dart';
import 'category/menue.dart';
import 'category/right_list_view.dart';
import 'category/search_bar.dart';
import 'category/sub_category.dart';
import 'category/categorydata.dart';
import 'comm/map_location.dart';

class CategoryHome extends StatefulWidget {
  @override
  CategoryHomePageState createState() => new CategoryHomePageState();
}

class CategoryHomePageState extends State<CategoryHome>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

  final GlobalKey<ScaffoldState> _scaffoldcgKey = GlobalKey<ScaffoldState>();
  var _futureBuilderFuture;

  GlobalKey<RightListViewState> rightListviewKey =
      new GlobalKey<RightListViewState>();
  GlobalKey<CategoryMenueState> categoryMenueKey =
      new GlobalKey<CategoryMenueState>();


  ScrollController _strollCtrl = ScrollController();
  bool showMore = false; //是否显示底部加载中提示
  double topimgheight = 160.0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var _categoryData=categoryData;
  List<SubCategoryListModel> listViewData = [];

  Map<String, dynamic> _machine;

   double dheight = MediaQuery
      .of(Constants.navigatorKey.currentContext)
      .size
      .height;

  double extralHeight = Klength.topBarHeight + //顶部标题栏高度
      Klength.bottomBarHeight + //底部tab栏高度
      10 + //状态栏高度ScreenUtil.statusBarHeight
      30; //IPhoneX底部状态栏bottomBarHeight


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
        child: Scaffold(
            backgroundColor: KColorConstant.backgroundColor,
            key: _scaffoldcgKey,
            body: EasyRefresh(
                header: ClassicalHeader(
                    refreshedText: "松开刷新",
                    refreshReadyText: "下拉刷新",
                    bgColor: KColorConstant.mainColor,
                    textColor: Color(0xFFFFFFFF)),
                onRefresh: () async {
                    _futureBuilderFuture = getmachinedata();
                    setState(() {  });
                },
                child:  FutureBuilder<Map<String, dynamic>>(
                    future: _futureBuilderFuture, builder: _buildMachineBody))));
  }

  Widget _buildMachineBody(
      BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {

    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
//       showLoadingDialog("获取咖啡机信息……");
        return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('获取咖啡机信息……')));
      case ConnectionState.done:
        if (snapshot.hasError){
           DialogUtils.showToastDialog(context,'Error: ${snapshot.error}');
          return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('获取咖啡机信息异常')));
        }
        if (snapshot.hasData && snapshot.data!=null)
            return mainbody(snapshot.data);
        }
        return errobody();

    }


Widget errobody() {
  return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
          height: dheight - Klength.bottomBarHeight,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            _topHeadbuild(success: false),
            Expanded(
                child: Container(
                    child: Center(
                        child: Text("没有找到附近等咖啡机")
                    )))
          ])));
}

  Widget mainbody(Map<String, dynamic> machine) {

    print("------drtypelist  --------");

    print(machine);
    _categoryData=machine['drinktypelist'] ;

    listViewData = _categoryData.map((i) {
      return SubCategoryListModel.fromJson(i);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: dheight - Klength.bottomBarHeight,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          _topHeadbuild(),
          Expanded(
              child: Container(
            child: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:Klength.blankwidth,left:Klength.blankwidth,right:Klength.blankwidth),
                  child: Card(
                      shape: KfontConstant.cardallshape,
                      elevation: 5,
                      color: Colors.white,
                      child: Container(
                        child: Center(
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFDF7EB),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Center(
                                          child: Icon(
                                            Icons.location_on,
                                            color: KColorConstant.mainColor,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text("${_machine['name']}(NO.${_machine['serialNumber']})",
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                        subtitle: Text.rich(
                                          TextSpan(
                                            text: '[${_machine['distance']*0.001}km]',
                                            style: TextStyle(
                                              fontSize: KfontConstant.title12,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '${_machine['address']}',
                                                  style: TextStyle(fontSize: KfontConstant.title12)),
                                               ],
                                          ),
                                        ),
                                        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                          return MapLocationScreen(_machine
                                          );
                                        })),
                                      ),

                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:Klength.blankwidth,right:Klength.blankwidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Card(
                            color: Color(0xFFffffff),
                            child: Container(
                              width: 80,
                              child: Column(
                                children: [
                                  Column(children: [
                                    Icon(Icons.search),
                                    Text("搜索",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                                  ],),
                                  CategoryMenue(
                                      key: categoryMenueKey,
                                      items: _categoryData.map((i) {
//                                        print(i['name'].toString());
                                        return i['name'].toString();
                                      }).toList(),
                                      itemHeight: 40,
                                      itemWidth: 75,
                                      menueTaped: menueItemTap),
                                ],
                              ),
                            ),
                          ),
                        ),
                        RightListView(
                            key: rightListviewKey,
                            height: MediaQuery.of(context).size.height -
                                extralHeight, //widget.rightListViewHeight,
                            dataItems: listViewData,
                            info: machine,
                            listViewChanged: listViewChanged)
                      ],
                    ),
                  ),
                )
              ],
            )),
          ))
        ] // listviewchildren(),
            ),
      ),
    );
  }

  List<Widget> listviewchildren() {
    List<Widget> itemlist = <Widget>[
      _topHeadbuild(),
      Container(
        height: 10,
      ),
      Expanded(
          child: Container(
        color: Colors.black26,
        child: SizedBox(
          height: 400,
        ),
      ))
    ];

    return itemlist;
  }

  Widget _topHeadbuild({bool success=false}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ComWidget.hometopbackground(context, topbgheight: 180.0, bottomheight: 70),
        ComWidget.topTitleWidget("菜单"),
        Positioned(
            top: (statusBarHeight + Klength.topBarHeight),
            left: 10,
            right: 10,
            child: mainheadbanner(success:success))
      ],
    );
  }

  Widget mainheadbanner({bool success=false}) {
    return Container(
      height: topimgheight,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(Klength.circular),
          child: Image.asset(
            "images/topbg_img.jpg",
            fit: BoxFit.cover,
//                    ),
          )),
    );

  }

  menueItemTap(int i) {
    rightListviewKey.currentState.jumpTopage(i);
  }

  listViewChanged(i) {
    this.categoryMenueKey.currentState.moveToTap(i);
  }

  void shownoopenmsg({String strt = '即将开放，敬请期待'}) {
    _scaffoldcgKey.currentState.showSnackBar(SnackBar(
      content: Text(strt),
    ));
  }


  @override
  void initState() {
    super.initState();
    _futureBuilderFuture=getmachinedata();
    // TODO: implement initState
    _strollCtrl.addListener(() {
      if (_strollCtrl.position.pixels == _strollCtrl.position.maxScrollExtent) {
//        print('滑动到了最底部${_strollCtrl.position.pixels}');
//        setState(() {
//          showMore = true;
//        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _futureBuilderFuture = null;
  }

  Future<Map<String, dynamic>> getmachinedata() async {
    final SharedPreferences prefs = await _prefs;
    _machine=jsonDecode(prefs.getString("machine"))??null ;

    print(_machine);
  /*  _categoryData.map((i) {
      print(i['name']);
      return i['name'];
    }).toList();

    listViewData = _categoryData.map((i) {
      return SubCategoryListModel.fromJson(i);
    }).toList();*/

    List<Map<String, dynamic>> drtypelist= await DataUtils.getDrinkTypeList(context, _machine['id']);


     _machine.putIfAbsent("drinktypelist", (){

      return drtypelist;});

   /*  _machine.putIfAbsent("drinklist", ()async{

      return json.encode(await DataUtils.getDrinkList(context, _machine['id'],drtypelist[0]['id']));});
*/

    return _machine;


  }

  Future<void> setdrinklist(List<Map<String, dynamic>> typelist){
  var tre=  typelist.map((it)async{
    Map<String, dynamic> drinkitem;
    /*{id: 15, name: 人气Top, deviceId: 16}, {id: 16, name: 经典拿铁, deviceId: 16}*/
    drinkitem={
      "name": it['name'],
      'icon': "",
      'ucid': "1",
    };
    List<Map<String, dynamic>> drinklist=await DataUtils.getDrinkList(context, _machine['id'],it['id']);

    /*{idSugar: true, image: http://wangpei-iot.oss-cn-beijing.aliyuncs.com/images/8ce3e597-9f9a-4511-b9f7-2550391f56cf.jpg?Expires=1915848218&OSSAccessKeyId=LTAI4FyaLq1QXuXkfsZExVpk&Signature=4KGZL5huy1Scx7ZRVxMbH%2BIK%2B9k%3D,
     coffeeName: 刘桂香, money: 0.01, id: 70, type: 1},
     {idSugar: true, image: http://wangpei-iot.oss-cn-beijing.aliyuncs.com/images/403fd4f7-ca83-44bb-b128-8bcdb50e697a.jpg?Expires=1915773859&OSSAccessKeyId=LTAI4FyaLq1QXuXkfsZExVpk&Signature=n4ADKVoTmNyUoEaDVQpt5%2FZLgoc%3D,
     coffeeName: 飞天茅台, money: 0.02, id: 69, type: 1}, {idSugar: false, image: http://wangpei-iot.oss-cn-beijing.aliyuncs.com/images/43753db9-8638-43f4-b4eb-54263e3e7640.jpg?Expires=1915773272&OSSAccessKeyId=LTAI4FyaLq1QXuXkfsZExVpk&Signature=o1qmLL5%2BrWEMBhaRf3gsLHUYZ6Y%3D, coffeeName: 生命之水, money: 0.01, id: 68, type: 1}]
*/
    drinkitem.putIfAbsent("data", () => drinklist
//        {
//      "sname": "热销1",
//      'icon': "",
//      'goodsid': "1",
//    }
    );
     return drinkitem;
   }).toList();
  }

  bool _loading = false;
  // 显示加载进度条
  void showLoadingDialog(String msg) async {
    setState(() {
      _loading = true;
    });
    await DialogUtils.showLoadingDialog(context, text: msg);
  }

  // 隐藏加载进度条
  hideLoadingDialog() {
    if (_loading) {
      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
    }
  }
}
