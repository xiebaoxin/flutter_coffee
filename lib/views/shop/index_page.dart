import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/shopDataUtils.dart';
import '../../globleConfig.dart';
import '../../routers/application.dart';
import '../../model/userinfo.dart';
import '../../components/banner.dart';
import '../../components/loading_gif.dart';
import 'recommedFloor.dart';
/*
import 'message_page.dart';
import 'indexHotList.dart';
import 'search/searchlist.dart'
import 'categrygoods_page.dart'*/

class IndexPageHome extends StatefulWidget {
  @override
  IndexPageHomeState createState() => new IndexPageHomeState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class IndexPageHomeState extends State<IndexPageHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _strollCtrl = ScrollController();

  var _futureAllBuilderFuture;
  var rightArrowIcon = Icon(Icons.chevron_right, color: Colors.black26);

  double scrollheight = 140;
  bool _isloaded = false;
  bool _showMore = false; //是否显示底部加载中提示


  @override
  Widget build(BuildContext context) {
    return Material(
        child:Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xFFFFFFFF),
            body: EasyRefresh(
                header: ClassicalHeader(
                    refreshedText: "松开刷新",
                    refreshReadyText: "下拉刷新",
                    bgColor: KColorConstant.themeColor,
                    textColor: Color(0xFFFFFFFF)
                ),
                onRefresh: () async {
                  _getalldata();
                },
                child: mainbody()),
            floatingActionButton:
                Visibility(
                    visible:_showMore,
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.vertical_align_top,
                        color: KColorConstant.mainColor,
                      ),
                      onPressed: () {
                        _strollCtrl.animateTo(60.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);

                        setState(() {
                          _showMore = false;
                        });
                      },
                    ))

                )
    );
  }

  TabController _tabController;

  Widget mainbody() {

    double deviceWidth = MediaQuery.of(context).size.width;
  double itemWidth = (deviceWidth / 2) - 1; // deviceWidth *

  return ListView(
      padding: EdgeInsets.all(0),
      controller: _strollCtrl,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _topHeadbuild(),
        buidWraplist(),

        floorAdsList(),

        Container(
          height: 8,
          color: KColorConstant.greybackcolor,
        ),
        Container(
          height: 310,
          child: Stack(
            children: <Widget>[
              _floorImagesList.length > 0
                  ? floorImage(_floorImagesList[0], type: 0)
                  : SizedBox(
                      height: 1,
                    ),
              Positioned(
                top: 145,
                left: 0,
                right: 0,
                child: _recommondList.length == 0
                    ? SizedBox(
                        height: 1,
                      )
                    : RecommendFloor(_recommondList),
              )
            ],
          ),
        ),
        Container(
          height: 8,
          color: KColorConstant.greybackcolor,
        ),
        Container(
          height: 310,
          child: Stack(
            children: <Widget>[
              _floorImagesList.length > 0
                  ? floorImage(_floorImagesList[1], type: 1)
                  : SizedBox(
                      height: 280,
                    ),
              Positioned(
                top: 145,
                left: 0,
                right: 0,
                child: _recommondList1.length == 0
                    ? SizedBox(
                        height: 1,
                      )
                    : RecommendFloor(_recommondList1),
              )
            ],
          ),
        ),

        Container(
          height: 8,
          color: KColorConstant.greybackcolor,
        ),
//        divdertext('热销商品'),
        Container(
          height: 47,
//          width: ScreenUtil.screenWidth,
          decoration: new BoxDecoration(
            color: Colors.white,
            image: new DecorationImage(
                image: new AssetImage('images/flider.jpg'), fit: BoxFit.fill),
            border: null,
          ),
        ),

      ],
    );
  }

  Widget floorAdsList() {
    double dvheight = 0.0;

    List<Widget> listWidgets = _floorAdImagesList.map((it) {
      if (it['active_id'] > 0) {
//        print(it);
        dvheight += 320.0;
        Map<String, dynamic> item = {};
        if (it['active'] != null) item = it['active'];

        List<Map<String, dynamic>> ddtl = List();
        if (it['list'] != null)
          it['list'].forEach((ele) {
            if (ele.isNotEmpty) {
              ddtl.add(ele);
            }
          });
        if (item.isNotEmpty && ddtl.length > 0)
          return floorPromtAds(item, ddtl);
        else{
          dvheight -= 160.0;
          return floorAdImages(it);
        }
        return SizedBox(height: 1,);
      } else {
        dvheight += 160.0;
        return floorAdImages(it);
      }
    }).toList();

    return Container(
      height: dvheight,
      child: Column(
        children: listWidgets,
      ),
    );
  }

  Widget floorAdImages(i) {
    return Container(
//          color: Color(0xFFFF9933),
      height: 160,
      child: Column(
        children: <Widget>[
          Container(
            height: 8,
            color: KColorConstant.greybackcolor,
          ),
          Container(padding: EdgeInsets.all(0), child: floorImage(i)),
        ],
      ),
    );
  }

  Widget floorImage(Map<String, dynamic> item, {int type = -1}) {
    return item == null
        ? divdertext('')
        : GestureDetector(
            onTap: () {
//              Application().adpage(context, item,type: type);
            },
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                fadeOutDuration: const Duration(milliseconds: 300),
                fadeInDuration: const Duration(milliseconds: 700),
                fit: BoxFit.cover,
                imageUrl: item['ad_code'],
                errorWidget: (context, url, error) => Container(
                    height: 75,
                    width: 75,
                    child: Image.asset(
                      'images/logo-no.png',
                    )),
                placeholder: (context, url) => Loading(),
              ),
            ));
  }

  Widget floorPromtAds(item, ddtl) {
    return Container(
//      height: 310,
      child: Column(
        children: <Widget>[
          Container(
            height: 8,
            color: KColorConstant.greybackcolor,
          ),
          Container(
            height: 310,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
//                      if (item['id'] > 0)
//                        print(item);
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(
//                            builder: (context) =>
//                                ActivePage(item['id'], item['title'])),
//                      );
                    },
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 300),
                        fadeInDuration: const Duration(milliseconds: 700),
                        fit: BoxFit.cover,
                        imageUrl: item['prom_img'],
                        errorWidget: (context, url, error) => Container(
                            height: 75,
                            width: 75,
                            child: Image.asset(
                              'images/logo-no.png',
                            )),
                        placeholder: (context, url) => Loading(),
                      ),
                    )),
                Positioned(
                  top: 145,
                  left: 0,
                  right: 0,
                  child: RecommendFloor(ddtl),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divdertext(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Divider(
            height: 2,
          ),
          width: ScreenUtil.screenWidthDp / 2 - 100,
        ),
        Text(title, style: KfontConstant.defaultAppbarTitleStyle),
        Container(
          child: Divider(
            height: 2,
          ),
          width: ScreenUtil.screenWidthDp / 2 - 100,
        ),
      ],
    );
  }

  Widget _topHeadbuild() {
//    return mainhead();
    return Stack(
//      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: scrollheight - 60,
                color: KColorConstant.themeColor, //KColorConstant.themeColor,
              ),
              ClipPath(
                // 只裁切底部的方法
                clipper: BottonClipper(),
                child: Container(
                  color: KColorConstant.themeColor,
                  height: scrollheight - 80,
                ),
              ),
              Container(
                height: 15,
                color: Color(0xFFFFFFFF),
              ),
            ],
          ),
        ),
        Positioned(top: 5, left: 16, right: 16, child: mainhead())
      ],
    );
  }

  Widget mainhead() {
    var ddre = _listbanner;
    List<String> banners = [];
    List<String> linkers = [];
    if (ddre != null) {
      ddre.forEach((ele) {
        if (ele.isNotEmpty &&
            ele['ad_code'].isNotEmpty &&
            ele['ad_link'].isNotEmpty) {
          banners.add(ele['ad_code'].toString());
          linkers.add(ele['ad_link'].toString());
        }
      });
    }
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
       /*   Container(
              height: scrollheight,
              child: Column(
                children: <Widget>[
                  banners.length <= 0
                      ? Image.asset(
                          "images/eggbg.png",
                          height: scrollheight,
                          width: ScreenUtil.screenWidth,
                          fit: BoxFit.fill,
                        )
                      : SwipperBanner(
                          banners: banners,
                          nheight: scrollheight,
                          urllinks: linkers,
                          iamgeitem: _listbanner,
                          widthsc: 32.0,
                        )
                ],
              )),*/
          SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget buidWraplist() {
    return Center(
      child: GridView(
        shrinkWrap: true, //在com中显示
        padding: EdgeInsets.all(5.0), //GridView内边距
        physics: const NeverScrollableScrollPhysics(), //禁止下滑
//          padding: EdgeInsets.all(1.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //水平子Widget之间间距
            crossAxisSpacing: 8.0,
            //垂直子Widget之间间距
            mainAxisSpacing: 5.0,
            crossAxisCount: 5,
            childAspectRatio: 0.85),
        /*   Wrap(
        spacing: 18,
        runSpacing: 10,*/
        children: <Widget>[
         buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
          buildIconitem('images/v20/wangwg.png', "药王谷",(){}),
        ],
      ),
    );
  }

  Widget buildIconitem(String asimg, String title,Function callback) {
    return
      GestureDetector(
        onTap: callback,
        child: Column(
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
        ),
      );
  }

  void shownoopenmsg({String strt = '即将开放，敬请期待'}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(strt),
    ));
  }
  List<Map<String, dynamic>> _floorAdImagesList = List();
  List<Map<String, dynamic>> _floorImagesList = List();

  List<Map<String, dynamic>> _recommondList = List();
  List<Map<String, dynamic>> _recommondList1 = List();
  List<Map<String, dynamic>> _recommondList2 = List();

  List<Map<String, dynamic>> _goodsList = List();

  List _listbanner = [];
  Future _getbannerdata() async {
    Map<String, String> params = {'objfun': 'getAppHomeAdv'};
//    Map<String, dynamic> response =
//        await HttpUtils.dioappi('Shop/getIndexData', params, context: context);
//    _listbanner = response["items"];
    return _listbanner;
  }


  Future _getalldata() async {
    _isloaded = false;
    await _getbannerdata();
    setState(() {
      _isloaded = true;
    });

    return _isloaded;
  }

  @override
  void initState() {
//    print("============indexpage======================");
//    if (!_isloaded) {
    super.initState();
    _futureAllBuilderFuture = _getalldata();

    _strollCtrl.addListener(() {
      if (_strollCtrl.position.pixels > 800) {
        setState(() {
          _showMore = true;
        });
      }
    });
//    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _futureAllBuilderFuture = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}

class BottonClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    // 路径
    var path = Path();
    // 设置路径的开始点
    path.lineTo(0, 0);
    path.lineTo(0, size.height-50);

    // 设置曲线的开始样式
    var firstControlPoint = Offset(size.width / 2, size.height);
    // 设置曲线的结束样式
    var firstEndPont = Offset(size.width, size.height - 50);
    // 把设置的曲线添加到路径里面
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);

    // 设置路径的结束点
    path.lineTo(size.width, size.height-50);
    path.lineTo(size.width, 0);

    // 返回路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


class ScreenUtil {
  static ScreenUtil instance = new ScreenUtil();

  //设计稿的设备尺寸修改
  double _designWidth;
  double _designHeight;

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;

  static double _bottomBarHeight;

  static double _textScaleFactor;

  ScreenUtil({double width, double height}) {
    _designWidth = width;
    _designHeight = height;
  }

  static ScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;

  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  ///每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactory => _textScaleFactor;

  ///设备的像素密度
  static double get pixelRatio => _pixelRatio;

  ///当前设备宽度 dp
  static double get screenWidthDp => _screenWidth;

  ///当前设备高度 dp
  static double get screenHeightDp => _screenHeight;

  ///当前设备宽度 px
  static double get screenWidth => _screenWidth;
  ///当前设备高度 px
  static double get screenHeight => _screenHeight;

  ///状态栏高度 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight;

  ///底部安全区距离
  static double get bottomBarHeight => _bottomBarHeight;

  ///实际的dp与设计稿px的比例
  get scaleWidth => _screenWidth / instance._designWidth;

  get scaleHeight => _screenHeight / instance._designHeight;

  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  setWidth(int width) => width * scaleWidth;
  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  L(int width) => this.setWidth(width);
  H(int height) => this.setHeight(height);
  /// 根据设计稿的设备高度适配
  /// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  setHeight(int height) => height * scaleHeight;

  ///字体大小适配方法
  ///@param fontSize 传入设计稿上字体的px ,
  ///@param allowFontScaling 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为true。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is true.
  setSp(int fontSize, [allowFontScaling = true]) => allowFontScaling
      ? setWidth(fontSize) * _textScaleFactor
      : setWidth(fontSize);
}