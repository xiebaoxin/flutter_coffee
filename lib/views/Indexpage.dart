import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import '../routers/application.dart';
import '../model/banner.dart';
import 'comm/comwidget.dart';
import '../components/in_text_dot.dart';
import '../constants/config.dart';
import '../model/globle_provider.dart';
import '../model/carts_provider.dart';
import '../globleConfig.dart';
import '../model/userinfo.dart';
import '../utils/dataUtils.dart';
import '../utils/DialogUtils.dart';
import '../utils/comUtil.dart';
import '../components/banner.dart';
import 'comm/gotopay.dart';
import '../views/person/message_list.dart';
import '../utils/shopDataUtils.dart';

class IndexPageHome extends StatefulWidget {
  @override
  HomeIndexPageState createState() => new HomeIndexPageState();
}

class HomeIndexPageState extends State<IndexPageHome>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  var _futureBannerBuilderFuture;
  var _futureLocationBuilderFuture;
  bool _hasnoread=true;
  double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

  ScrollController _strollCtrl = ScrollController();
  Userinfo _userinfo;
  bool showMore = false; //是否显示底部加载中提示
  double topimgheight = 160.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
        child: Scaffold(
            backgroundColor: KColorConstant.backgroundColor,
            body: EasyRefresh(
                header: ClassicalHeader(
                    refreshedText: "松开刷新",
                    refreshReadyText: "下拉刷新",
                    bgColor: KColorConstant.mainColor,
                    textColor: Color(0xFFFFFFFF)),
                onRefresh: () async {
//                  await DataUtils().checkUpdateApp(context);
                  await freshdata();
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
                      child: FlatButton(
                        onPressed: () async {
                          String v = await ComFun.scanqr();
                          print(v);
                          if (v = null) {
                            Map<String, dynamic> payoddata = {
                              "drinkId": '61',
                              "sugarRule": "1", //糖规则（0=无糖，1=少糖，2=标准，3=多糖）
                              "deviceId": '33', //设备id
                            };

                            Navigator.of(context)
                                .push(PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return GoToPayPage(
                                        "",
                                        data: payoddata,
                                        money: 0.01,
                                      );
                                    }))
                                .then((value) => Navigator.of(context).pop());
                          }
                        },
                        color: KColorConstant.mainColor,
                        child: Image.asset(
                          "images/qrscan.png",
                          height: 25,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
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
                                            Application()
                                                .checklogin(context, () {});
                                          }
                                        : () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      MessageList()),
                                            ).then((v) {
                                              freshdata();
                                            });
                                          }),
                              ),
                            ),

                   Visibility(
                                  visible:! _hasnoread,
                                  child: Positioned(
                                      top: 12, right: 0, child: InTextDot())
                   )

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
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildIconitem("无人售卖机", "特价爆款", "", ()async {
             /*   print("---------=-=-=----------");
                Map<String, dynamic> param={
                  "stores_id":"10",
                  "barcode_id":'13'
                };
                print(await ShopDataUtils.goodsDetails(param));*/
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
    ];

    if (_location == null)
      itemlist.add(
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "正在搜索附近咖啡机……",
            style: TextStyle(fontSize: 10),
          ),
        )),
      );
    else {
      itemlist.add(FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureLocationBuilderFuture,
          builder: _buildMachineListBody));
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
    if (_location != null && _location.address != null)
      itemlist.add(Text(
        "${_location.address ?? 'null'}[${_location.latLng.latitude},${_location.latLng.longitude},${_location.altitude}]",
        softWrap: true,
        textAlign: TextAlign.center,
      ));
    return itemlist;
  }

  Widget _buildMachineListBody(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('正在获取附近咖啡机信息……', style: TextStyle(fontSize: 10))));
      case ConnectionState.done:
        if (snapshot.hasError) {
          DialogUtils.showToastDialog(context, 'Error: ${snapshot.error}');
          return Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('获取附近咖啡机信息异常', style: TextStyle(fontSize: 10))));
        }
        if (snapshot.hasData && snapshot.data != null) {
          if (_shopsList != null && _shopsList.length > 0) {
            return Column(
              children:
                  _shopsList.map((it) => ComWidget.machineitem(it)).toList(),
            );
          } else
            return ComWidget.machineitem({});
        }
    }
    return ComWidget.machineitem({});
  }

  Widget _topHeadbuild() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ComWidget.hometopbackground(context,
            topbgheight: 180.0, bottomheight: 78),
        topbarWidget(),
        Positioned(
            top: (statusBarHeight + Klength.topBarHeight + 5),
            left: 10,
            right: 10,
            child: mainheadbanner())
      ],
    );
  }

  Widget mainheadbanner() {
    return FutureBuilder(
      future: _futureBannerBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot就是_calculation在时间轴上执行过程的状态快照
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('需重新加载'),
            )); //如果_calculation未执行则提示：请点击开始
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
          onTap: callback,
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

  void shownoopenmsg({String strt = '即将开放，敬请期待'}) async {
    await DialogUtils.showToastDialog(context, strt);
  }

  List<Map<String, dynamic>> _shopsList = List();
  Future<List<Map<String, dynamic>>> _getDeviceList() async {
    if (_location != null && _location.latLng != null) {
      Map<String, String> params = {
        "longitudeLatitude":
            "${_location.latLng.longitude},${_location.latLng.latitude}",
        "range": "5000"
      };
      _shopsList = await DataUtils.getNearByDevice(context, params);
      /*[{latitudeLongitude: 113.926727,22.647089,
     address: 广东省深圳市宝安区创维科技工业园, serialNumber: 1234567891,
     distance: 361, name: 测试, id: 9, status: 0},
    */
      if (_shopsList != null && _shopsList.length > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (int i = 0; i < _shopsList.length; i++) {
          if (_shopsList[i]['status'] == 1) {
            await prefs.setString("machine", jsonEncode(_shopsList[i]));
            break;
          }
        }
      }
//      setState(() {  });
    }
    return _shopsList;
  }

  Future _getbannerdata() async {

    BannerList banners;

    List<Map<String, dynamic>> imagessList = List();
    List<Map<String, dynamic>> listbanner =
        await DataUtils.getIndexTopSwipperBanners(context);

    /*
    *{"code":200,"message":"成功!","data":[{"orderId":2,"link":1,
    * "linkUrl":"%","linkType":3,"title":"汽车","picture":"https://dss0.bdstatic.co"}]}
    * */
    if (listbanner != null && listbanner.length > 0) {
      listbanner.forEach((ele) {
        if (ele['picture'] != null) {
          var el = {
            'ad_code': ele['orderId'],
            'ad_link': ele['picture'],
            'ad_href': ele['linkUrl'],
            'ad_type': ele['linkType']
          };
          imagessList.add(el);
        }
      });

      banners = BannerList.fromJson(imagessList);
    }

    setState(() {  });
    return banners;
  }

  @override
  void initState() {
    getmsgreaed();
    fetchLocation();
    super.initState();

    _futureBannerBuilderFuture = _getbannerdata();
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
    _futureLocationBuilderFuture = null;
  }

  void getmsgreaed()async{
    _hasnoread=await DataUtils.getMyMessageReaded(context);

    setState(() {  });
  }

  void freshdata() async {
    if (mounted) {
      var cartdemoInfo = Provider.of<CartsProvider>(context);
      await cartdemoInfo.initcartdemo();
    }

    getmsgreaed();
    _futureBannerBuilderFuture = _getbannerdata();
    _getDeviceList();

    setState(() {});
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
  void fetchLocation() async {
    if (await Permission.location.request().isGranted) {
      final location = await AmapLocation.instance.fetchLocation();

      setState(() => _location = location);
      _futureLocationBuilderFuture = _getDeviceList();
      print(
          "--${location.address},[${location.latLng.latitude},${location.latLng.longitude}],${location.altitude}--");
    }
  }
}
