import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/banner.dart';
import '../utils/comUtil.dart';
import '../utils/utils.dart';
import '../components/fiexdAppbar.dart';
import '../components/toproundbg.dart';
import '../constants/config.dart';
import '../model/globle_provider.dart';
import '../globleConfig.dart';
import '../routers/application.dart';
import '../model/userinfo.dart';
import '../utils/dataUtils.dart';
import '../utils/DialogUtils.dart';
import '../components/banner.dart';
import 'usersetting.dart';

class IndexPageHome extends StatefulWidget {
  @override
  HomeIndexPageState createState() => new HomeIndexPageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class HomeIndexPageState extends State<IndexPageHome>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _futureBannerBuilderFuture;

  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo;

  String _istoken = '';
  bool showMore = false; //是否显示底部加载中提示
  double topimgheight = 150.0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> _tabs = [
    {
      'text': "",
      'cat_id': 0,
      'lists': [],
    }
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
              child: Scaffold(
                  backgroundColor:KColorConstant.backgroundColor,
//          backgroundColor: KColorConstant.mainColor,
                  key: _scaffoldKey,
                  appBar: FiexdAppbar(
                    contentHeight: 55.0,
                    contentChild: myappbar(),
                    statusBarColor: KColorConstant.mainColor,
                  ),
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

                          _page = 0;
                          _shopsList = List();
                          comShopList();
                        });

                      },
                      child: mainbody())));

  }

  Widget myappbar() {
    return Container(
        padding: EdgeInsets.all(2),
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      "images/logo.png",
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                  )),
              Expanded(
                flex: 8,
                child:GestureDetector(
                  onTap:null,
                  child: Center(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            GlobalConfig.appName,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize:16,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                )

                ,),
              Expanded(
                  flex: 1,
                  child:  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:
//                        使用Consumer -局部刷新而不是整个页面
                    Consumer<GlobleProvider>(
                      builder: (context, GlobleProvider provider, _) =>
                      ///三个参数：(BuildContext context, T model, Widget child)
                      ///context： context 就是 build 方法传进来的 BuildContext 在这里就不细说了
                      ///T：获取到的最近一个祖先节点中的数据模型。
                      ///child：它用来构建那些与 Model 无关的部分，在多次运行 builder 中，child 不会进行重建
                      ///=>返回一个通过这三个参数映射的 Widget 用于构建自身
                      Center(
                          child:  IconButton(
                        icon: !provider.loginStatus
                            ? Icon(
                          Icons.perm_identity,
                          color: Colors.white,
                        )
                            : Icon(
                          Icons.person,
                          color: Colors.greenAccent,
                        ),
                        onPressed: !provider.loginStatus
                            ? () {
                          Application().checklogin(context, () {
                            _getalldata();
                          });
                        }
                            : () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => SetUserinfo()),
                          ).then((v){
                            freshdata();
                          });
                        })
                      ),
                    )
                   ,
                  )
              )
            ]));
  }

  Widget mainbody() {
    return ListView(
      padding: EdgeInsets.all(0),
      controller: _strollCtrl,
      physics: const AlwaysScrollableScrollPhysics(),
      children: listviewchildren(),
    );
  }

  List<Widget> listviewchildren() {
    List<Widget> toplist = <Widget>[
      _topHeadbuild(),
     /* Visibility(
          visible: _mylocklist.length > 0, child: _buildLockItemView()),
    */ /* Container(
        height: 5,
        color: KColorConstant.greybackcolor,
      ),
*/
      Container(
        height: 5,
      ),

    ];

    if (_shopsList != null && _shopsList.length > 0){
  /*    toplist.add(divdertext('社区商户推荐'));
      _shopsList.forEach((it) {
        toplist.add(ShopItemWidget(List(),it));
      });*/

      if (showMore) {
        toplist.add(divdertext('没有更多了'));
      }
    }



    return toplist;
  }

  Widget _topHeadbuild() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
//                width: 120,
                height: topimgheight,
                decoration: BoxDecoration(
                    color: KColorConstant.mainColor,
                    borderRadius:
                    BorderRadius.only(
                        bottomLeft:Radius.circular(50) ,
//                        topRight: Radius.circular(20)
                    )),

              ),
            /*  Container(
                height: topimgheight - 80,
                color: KColorConstant.mainColor,
              ),
              ClipPath(
                // 只裁切底部的方法
                clipper: BottonClipper(),
                child: Container(
                  color: KColorConstant.mainColor,
                  height: topimgheight - 100,
                ),
              ),*/
              Container(
                height: 42,
                color: KColorConstant.backgroundColor,
              ),
            ],
          ),
        ),
        Positioned(top: 5, left: 16, right: 16, child: mainhead())
      ],
    );
  }

  Widget mainhead() {
    return FutureBuilder(
      future: _futureBannerBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot就是_calculation在时间轴上执行过程的状态快照
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('需重新加载'); //如果_calculation未执行则提示：请点击开始
          case ConnectionState.waiting:
            return Image.asset(
              "images/topbg_img.jpg",
              height: topimgheight,
              fit: BoxFit.fill,
            );
//                  return new Text('Awaiting result...');  //如果_calculation正在执行则提示：加载中
          default: //如果_calculation执行完毕
            if (snapshot.hasError) //若_calculation执行出现异常
              return Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    Text('Error: ${snapshot.error}'),
                    Image.asset(
                      "images/topbg_img.jpg",
                      height: topimgheight,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
              );
            else {
              if (snapshot.hasData) {
                BannerList banners=snapshot.data;
                return Container(
                    padding: EdgeInsets.all(0),
                    height: topimgheight,
                    decoration: new BoxDecoration(
                      border:
                      null, // Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: banners !=null && banners.items.length >0
                        ? SwipperBanner(
                      bannerlist: banners,
                      nheight: topimgheight,
                      widthsc: 32.0,
                    )
                        : Image.asset(
                  "images/topbg_img.jpg",
                  height: topimgheight,
                  fit: BoxFit.fill,
                ));
              } else {
                return Center(
                  child: Image.asset(
                    "images/topbg_img.jpg",
                    height: topimgheight,
                    fit: BoxFit.fill,
                  ),
                );
              }
            } //若_calculation执行正常完成
//                    return new Text('Result: ${snapshot.data}');
        }
      },
    );
  }

  Widget seachbar() {
    return Expanded(
        flex: 9,
        child: GestureDetector(
            onTap: () {
//                      SearchTopBarActionWidget(
//                        onActionTap: () => goSearchList(context,controller.text),
//                      )
            },
            child: Container(
              height: 34,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
//                            color: Color.fromRGBO(240, 240, 240, 0.5),
                borderRadius: BorderRadius.circular(17.0),
                border: Border.all(width: 0.5, color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2.0, 5, 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          "搜一搜",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF979797),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*   Container(
                                height: 34,
                                width: 60,
//                padding: EdgeInsets.all(2.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:Color(0xaFe7281d),
                                    borderRadius: BorderRadius.circular(17.0)),
                                child:Text("搜索",style: TextStyle(color: Color(0xFFFFFFFF)),))*/
                ],
              ),
            )));
  }

  Widget getIndexCatList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: TabBar(
            indicatorColor: KColorConstant.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            labelColor: KColorConstant.themeColor,
            indicatorWeight: 2,
            labelPadding: EdgeInsets.only(left: 15, right: 8),
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
            TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            tabs: _tabs
                .map((i) => Container(
              child: Tab(
                text: i['text'],
              ),
            ))
                .toList()),
      ),
    );
  }

  Widget divdertext(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Divider(
              height: 2,
            ),
            width: MediaQuery.of(context).size.width / 2 - 100,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xaf666666),
              )),
          Container(
            child: Divider(
              height: 2,
            ),
            width: MediaQuery.of(context).size.width / 2 - 100,
          ),
        ],
      ),
    );
  }


  Widget buildIconitem(String asimg, String title) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 45,
            width: 45,
            decoration: new BoxDecoration(
              color: Colors.white,
              image: new DecorationImage(
                image: ExactAssetImage(asimg),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3f3f3f),
          ),
        )
      ],
    );
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
    if(_listbanner!=null && _listbanner.length>0)
    {
      _listbanner.forEach((ele) {
        if(ele['PICURL']!=null){
          var el = {'ad_code': ele['RID'],
            'ad_link': servpic(ele['PICURL'])
          };
          imagessList.add(el);
        }

      });

      banners = BannerList.fromJson(imagessList);

    }
    _getbannerd = true;
    return banners;
  }

  Future _getalldata() async {

  }

  @override
  void initState() {
    super.initState();
    _futureBannerBuilderFuture = _getbannerdata();
    // TODO: implement initState
    _getalldata();
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
    _futureBannerBuilderFuture=null;
  }

 void freshdata() async{
   _getalldata();

   _getbannerd = false;
   _futureBannerBuilderFuture = _getbannerdata();

   _page = 0;
   _shopsList = List();
   await comShopList();
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
