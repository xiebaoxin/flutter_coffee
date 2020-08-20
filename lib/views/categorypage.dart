import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/banner.dart';
import 'comm/comwidget.dart';
import '../components/in_text_dot.dart';
import '../utils/utils.dart';
import '../constants/config.dart';
import '../model/globle_provider.dart';
import '../globleConfig.dart';
import '../utils/DialogUtils.dart';
import '../components/banner.dart';
import 'category/menue.dart';
import 'category/right_list_view.dart';
import 'category/search_bar.dart';
import 'category/sub_category.dart';
import 'category/categorydata.dart';


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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _futureBannerBuilderFuture;

  var _categoryData=[
    {"name":"dsfad",'icon':"",'ucid':"1","data":[
      {"sname":"dsfad",'icon':"",'goodsid':"1",},
      {"sname":"dsad",'icon':"",'goodsid':"2",},
      {"sname":"ds3dd",'icon':"",'goodsid':"3",},
      {"sname":"dsfa3333d",'icon':"",'goodsid':"4"}
    ]},
    {"name":"2ds2fad",'icon':"",'ucid':"2","data":[
    {"sname":"2dsfad",'icon':"",'goodsid':"1",},
    {"sname":"2dsad",'icon':"",'goodsid':"2",},
    {"sname":"2ds3dd",'icon':"",'goodsid':"3",},
    {"sname":"2dsfa3333d",'icon':"",'goodsid':"4"}]},
    {"name":"3ds432fad",'icon':"",'ucid':"3","data":[
      {"sname":"3dsfad",'icon':"",'goodsid':"1",},
      {"sname":"3dsad",'icon':"",'goodsid':"2",},
      {"sname":"3ds3dd",'icon':"",'goodsid':"3",},
      {"sname":"3dsfa3333d",'icon':"",'goodsid':"4"
    }]},
    {"name":"444eer4",'icon':"",'ucid':"4","data":[
      {"sname":"4dsfad",'icon':"",'goodsid':"1",},
      {"sname":"4dsad",'icon':"",'goodsid':"2",},
      {"sname":"4ds3dd",'icon':"",'goodsid':"3",},
      {"sname":"4dsfa3333d",'icon':"",'goodsid':"4"
    }]}];

  GlobalKey<RightListViewState> rightListviewKey =
  new GlobalKey<RightListViewState>();
  GlobalKey<CategoryMenueState> categoryMenueKey =
  new GlobalKey<CategoryMenueState>();
  List<SubCategoryListModel> listViewData = [];

  ScrollController _strollCtrl = ScrollController();
  bool showMore = false; //是否显示底部加载中提示
  double topimgheight = 160.0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
        child: Scaffold(
            backgroundColor: KColorConstant.backgroundColor,
//          backgroundColor: KColorConstant.mainColor,
            key: _scaffoldKey,
            body: EasyRefresh(
                header: ClassicalHeader(
                    refreshedText: "松开刷新",
                    refreshReadyText: "下拉刷新",
                    bgColor: KColorConstant.mainColor,
                    textColor: Color(0xFFFFFFFF)),
                onRefresh: () async {
                  setState(() {
                    _getbannerd = false;
                    _futureBannerBuilderFuture = _getbannerdata();

                  /*  _page = 0;
                    _shopsList = List();
                    comShopList();*/
                  });
                },
                child: mainbody())));
  }

  Widget mainbody() {
    final double dheight=MediaQuery.of(context).size.height;

    double extralHeight = Klength.topBarHeight + //顶部标题栏高度
        Klength.bottomBarHeight + //底部tab栏高度
        10 + //状态栏高度ScreenUtil.statusBarHeight
        30; //IPhoneX底部状态栏bottomBarHeight

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: dheight-Klength.bottomBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        /*  padding: EdgeInsets.all(0),
          controller: _strollCtrl,
          physics: const AlwaysScrollableScrollPhysics(),*/
          children:[
            _topHeadbuild(),
            Container(
              height: 10,
            ),
            Expanded(child:
            Container(

              child: Center(child:
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Klength.blankwidth),
                    child: Card(
                        shape: KfontConstant.cardallshape,
                        elevation: 5,
                        color: Colors.white,
                        child: Container(
                          height: 100,
                          child: Center(
                            child: Container(

                              child: Row(
                                children: <Widget>[

                                          Container(
                                              padding: EdgeInsets.all(5),
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color(0xffFDF7EB),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Center(
                                                  child: Icon(Icons.location_on,color: KColorConstant.mainColor,),
                                                ),
                                              )),
                                          Expanded(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text("万达新天地咖啡机(NO.0012)",style: TextStyle(fontWeight: FontWeight.bold),),
                                              subtitle: Text.rich(
                                                TextSpan(
                                                  text: '[2.3km]',
                                                  style: TextStyle(
                                                    fontSize: KfontConstant.title12,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: '深圳宝安南山区万象城3楼',
                                                        style: TextStyle(fontSize: KfontConstant.title12)),
                                                      ],
                                                ),
                                              ),
                                              trailing: Icon(Icons.chevron_right),
                                          ),),)

                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Klength.blankwidth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Card(
                              color: Color(0xFFffffff),

                              child:Container(
                                width:  75,
                                child:CategoryMenue(
                                    key: categoryMenueKey,
                                    items: _categoryData.map((i){
                                      print(i['name'].toString());
                                      return i['name'].toString();
                                    }).toList(),
                                    itemHeight:40,
                                    itemWidth: 75,
                                    menueTaped: menueItemTap) ,
                              ) ,
                            ),
                          ),
               RightListView(
                              key: rightListviewKey,
                              height:MediaQuery.of(context).size.height-extralHeight ,//widget.rightListViewHeight,
                              dataItems: listViewData,
                              listViewChanged: listViewChanged)

                        ],
                      ),
                    ),
                  )
                ],
              )),))
          ]// listviewchildren(),
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
      Expanded(child:
      Container(
        color: Colors.black26,
        child: SizedBox(height: 400,),))

    ];

    return itemlist;
  }

  Widget _topHeadbuild() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ComWidget()
            .hometopbackground(context, topbgheight: 180.0, bottomheight: 85),
        ComWidget().topTitleWidget("菜单"),
        Positioned(top: ( statusBarHeight+Klength.topBarHeight), left: 10, right: 10, child: mainheadbanner())
      ],
    );
  }

  Widget mainheadbanner() {
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

    return FutureBuilder(
      future: _futureBannerBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot就是_calculation在时间轴上执行过程的状态快照
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('需重新加载'); //如果_calculation未执行则提示：请点击开始
          case ConnectionState.waiting:
            return Container(
                height: topimgheight,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(Klength.circular),
                    child: Image.asset(
                      "images/topbg_img.jpg",
                      height: topimgheight,
                      fit: BoxFit.fill,
                    )));
//                  return new Text('Awaiting result...');  //如果_calculation正在执行则提示：加载中
          default: //如果_calculation执行完毕
            if (snapshot.hasError) //若_calculation执行出现异常
              return Container(
                height: topimgheight,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(Klength.circular),
                    child: Image.asset(
                      "images/topbg_img.jpg",
                      height: topimgheight,
                      fit: BoxFit.fill,
                    )),
              );
            else {
              if (snapshot.hasData) {
                BannerList banners = snapshot.data;
                return Container(
                    height: topimgheight,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(Klength.circular),
                        child: banners != null && banners.items.length > 0
                            ? SwipperBanner(
                          bannerlist: banners,
                          nheight: topimgheight,
                          widthsc: 32.0,
                        )
                            : Image.asset(
                          "images/topbg_img.jpg",
                          height: topimgheight,
                          fit: BoxFit.cover,
                        )));
              } else {
                return Container(
                  height: topimgheight,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Klength.circular),
                      child:
//                      AspectRatio(
//                          aspectRatio: 16.0 / 12.0,
//                          child:
                      Image.asset(
                        "images/topbg_img.jpg",
                        fit: BoxFit.cover,
//                    ),
                      )),
                );
              }
            } //若_calculation执行正常完成
//                    return new Text('Result: ${snapshot.data}');
        }
      },
    );
  }


  menueItemTap(int i) {
    rightListviewKey.currentState.jumpTopage(i);
  }


  listViewChanged(i) {
    this.categoryMenueKey.currentState.moveToTap(i);
  }


  void shownoopenmsg({String strt = '即将开放，敬请期待'}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(strt),
    ));
  }

  int _page = 0;
  int pagesize = 20;
  List<Map<String, dynamic>> _shopsList = List();
  Future comShopList() async {
/*    List<Map<String, dynamic>> shopsList = List();
    shopsList = await ShopUtils.priorityShopList(context, _page, pagesize: pagesize);

    if (shopsList.length > 0) {
      _page+=pagesize;
      _shopsList += shopsList;
      setState(() { });
    }else
      setState(() {
        showMore = true;
      });*/
  }

  List<Map<String, dynamic>> _listbanner = [];
  bool _getbannerd = false;
  Future _getbannerdata() async {
    BannerList banners;
    if (_getbannerd) return _listbanner;
    List<Map<String, dynamic>> imagessList = List();
//    _listbanner = await DataUtils.getIndexTopSwipperBanners(context);
    if (_listbanner != null && _listbanner.length > 0) {
      _listbanner.forEach((ele) {
        if (ele['PICURL'] != null) {
          var el = {'ad_code': ele['RID'], 'ad_link': servpic(ele['PICURL'])};
          imagessList.add(el);
        }
      });

      banners = BannerList.fromJson(imagessList);
    }
    _getbannerd = true;
    return banners;
  }

  @override
  void initState() {
    super.initState();
    freshdata();
    // TODO: implement initState
    _strollCtrl.addListener(() {
      if (_strollCtrl.position.pixels == _strollCtrl.position.maxScrollExtent) {
//        print('滑动到了最底部${_strollCtrl.position.pixels}');
        setState(() {
          showMore = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _futureBannerBuilderFuture = null;
  }

  void freshdata() async {

    _getbannerd = false;
    _futureBannerBuilderFuture = _getbannerdata();
    _categoryData.map((i){
      print(i['name']);
      return i['name'];
    }).toList();
    /*_page = 0;
    _shopsList = List();
    await comShopList();*/
    listViewData = _categoryData.map((i){
      return SubCategoryListModel.fromJson(i);
    }).toList();
    setState(() {

    });
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
