import 'dart:io';
import 'dart:ui';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import '../routers/application.dart';
import '../model/banner.dart';
import 'comm/comwidget.dart';
import '../components/in_text_dot.dart';
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

class HomeIndexPageState extends State<IndexPageHome>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin,AmapSearchDisposeMixin{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _futureBannerBuilderFuture;

  final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo;
  bool showMore = false; //是否显示底部加载中提示
  double topimgheight = 160.0;
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

                    _page = 0;
                    _shopsList = List();
                    comShopList();
                  });
                },
                child: mainbody())));
  }

  Widget topbarWidget() {

    return Positioned(
        top: statusBarHeight,
        left: 0,
        right: 0,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              height: Klength.topBarHeight,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                      child: Image.asset(
                        "images/qrscan.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.fill,
                      )
                      ,
                    ),
                    Expanded(
                        child: Container(
                      height: 34,
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // Color.fromRGBO(240, 240, 240, 0.5),
                        borderRadius: BorderRadius.circular(17.0),
                        border: Border.all(width: 0.5, color: Color(0xfffffff)),
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
                                  color: Color(0xFF979797),
                                  size: 22,
                                ),
                                Text(
                                  "卡布奇诺",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF979797),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(0),
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
                                child: Stack(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: !provider.loginStatus
                                        ? Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.message,
                                            color: Colors.white60,
                                          ),
                                    onPressed: !provider.loginStatus
                                        ? () {
                                            Application().checklogin(context,
                                                () {

                                            });
                                          }
                                        : () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      SetUserinfo()),
                                            ).then((v) {
                                              freshdata();
                                            });
                                          }),
                              ),
                            ),
                            Positioned(top: 12, right: 0, child: InTextDot())
                          ],
                        )),
                      ),
                    )
                  ]),
            )));
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
    List<Widget> itemlist = <Widget>[
      _topHeadbuild(),
      Container(
        height: 10,
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildIconitem("无人售卖机", "特价爆款", "", () {
                ;
              }),
              buildIconitem("优惠劵", "先领劵更划算", "", () {
                ;
              }),
              buildIconitem("咖啡钱包", "充5赠3", "", () {
                ;
              }),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 0),
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          elevation: 1.0,
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("附近的咖啡机"),
                Text("查看更多》"),
              ],
            ),
          )),
        ),
      ),
      machineitem({}),
      machineitem({}),
      machineitem({}),

    ];


    if (_shopsList != null && _shopsList.length > 0){
      _shopsList.forEach((it) {
        itemlist.add(machineitem(it),);
      });

    }
    itemlist.add(Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
              ),
            )),
      ),
    ));

    itemlist.add(Visibility(
        visible: _location!=null,
        child: Text(
      _location.toString(),
      textAlign: TextAlign.center,
    )));
    return itemlist;
  }

  Widget _topHeadbuild() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ComWidget()
            .hometopbackground(context, topbgheight: 180.0, bottomheight: 55),
        topbarWidget(),
        Positioned(top:( statusBarHeight+Klength.topBarHeight), left: 10, right: 10, child: mainheadbanner())
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

  Widget buildIconitem(
      String title, String subtitle, String asimg, Function callback) {
    double deviceWidth = MediaQuery.of(context).size.width;

    var bgColor = Color(0xFFFEFFFF); // string2Color(i.bgColor);
    double itemWidth = (deviceWidth / 3) - 13; // deviceWidth * 100 / 360;
    ShapeBorder _shape = const RoundedRectangleBorder(
//      side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
      ),
    );

    return Container(
        width: itemWidth,
        margin: EdgeInsets.all(0),
        child: InkWell(
          onTap: () {
//            Application.goodsDetail(context, item['goods_id'].toString());
          },
          child: Card(
            color: bgColor,
            // This ensures that the Card's children are clipped correctly.
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0),
            shape: _shape, //,
            elevation: 1.0,
            child: Container(
              margin: EdgeInsets.all(8),
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: KfontConstant.title16,
                          color: KColorConstant.mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      softWrap:
                          true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                      overflow: TextOverflow
                          .ellipsis, //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                      style: TextStyle(
                          fontSize: KfontConstant.title12,
                          color: KColorConstant.mainColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget machineitem(Map<String, dynamic> machine) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 0),
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: Container(
            child: Padding(
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
                  TextSpan(
                      text: '\t\n 营业【0：00-24：00】',
                      style: TextStyle(fontSize: KfontConstant.title12, color: KColorConstant.mainColor)),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right)
         /*   Container(
              width: 55,
              child: Row(
                children: <Widget>[
                  Text("去看看",style: TextStyle(fontSize: 10),),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),*/
          ),
          /*   Column(
            children: <Widget>[
              SizedBox(height: 40,),
            ],
          ),*/
        )),
      ),
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

  Future _getinitdata() async {
    await AmapCore.init(GlobalConfig.aMapIosAppId);
    await AmapService.instance.init(
      iosKey: GlobalConfig.aMapIosAppId,
      androidKey: GlobalConfig.aMapAppId,
    );
    await fetchLocation();
  }

  @override
  void initState() {
    _getinitdata();
    super.initState();
    _futureBannerBuilderFuture = _getbannerdata();
    // TODO: implement initState
//    _getalldata();
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
  Location _location;
void  fetchLocation() async {
  if(await Permission.location.request().isGranted) {
  final location = await AmapLocation.instance.fetchLocation();

  print("--${location.address},[${location.latLng.latitude},${location.latLng.longitude}],${location.altitude}--");
  setState(() => _location = location);
  }
  }



}
