import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter_coffee/stubs/amap_stub.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  HomeIndexPageState createState() => HomeIndexPageState();
}

class HomeIndexPageState extends State<IndexPageHome>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  var _futureBannerBuilderFuture;
  var _futureLocationBuilderFuture;
  bool _hasnoread=true;
  double statusBarHeight = MediaQueryData.fromView(PlatformDispatcher.instance.implicitView!).padding.top;

  ScrollController _strollCtrl = ScrollController();
  Userinfo? _userinfo;
  bool showMore = false;
  double topimgheight = 160.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
        child: Scaffold(
            backgroundColor: KColorConstant.backgroundColor,
            body: EasyRefresh(
                header: ClassicHeader()),
                onRefresh: () async {
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
                      child: TextButton(
                        onPressed: () async {
                          String v = await ComFun.scanqr();
                          print(v);
                          if (v == null) {
                            Map<String, dynamic> payoddata = {
                              "drinkId": '61',
                              "sugarRule": "1",
                              "deviceId": '33',
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
                        style: TextButton.styleFrom(
                          backgroundColor: KColorConstant.mainColor,
                        ),
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
                            Colors.white,
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
                          Consumer<GlobleProvider>(
                        builder: (context, GlobleProvider provider, _) =>
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
                                              MaterialPageRoute(
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
    if (_location != null && _location!.address != null)
      itemlist.add(Text(
        "${_location!.address ?? 'null'}[${_location!.latLng.latitude},${_location!.latLng.longitude},${_location!.altitude}]",
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
          if (_shopsList.length > 0) {
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
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('需重新加载'),
            ));
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
          default:
            if (snapshot.hasError)
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
                          Image.asset(
                        "images/topbg_img.jpg",
                        fit: BoxFit.cover,
                      )),
                );
              }
            }
        }
      },
    );
  }

  Widget buildIconitem(
      String title, String subtitle, String asimg, Function callback) {
    double deviceWidth = MediaQuery.of(context).size.width;

    var bgColor = Color(0xFFFEFFFF);
    double itemWidth = (deviceWidth / 3) - 13;
    ShapeBorder _shape = const RoundedRectangleBorder(
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
          onTap: () => callback(),
          child: Card(
            color: bgColor,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0),
            shape: _shape,
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
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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

  List<Map<String, dynamic>> _shopsList = [];
  Future<List<Map<String, dynamic>>> _getDeviceList() async {
    if (_location != null && _location!.latLng != null) {
      Map<String, String> params = {
        "longitudeLatitude":
            "${_location!.latLng.longitude},${_location!.latLng.latitude}",
        "range": "5000"
      };
      _shopsList = await DataUtils.getNearByDevice(context, params);
      if (_shopsList.length > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (int i = 0; i < _shopsList.length; i++) {
          if (_shopsList[i]['status'] == 1) {
            await prefs.setString("machine", jsonEncode(_shopsList[i]));
            break;
          }
        }
      }
    }
    return _shopsList;
  }

  Future _getbannerdata() async {

    BannerList? banners;

    List<Map<String, dynamic>> imagessList = [];
    List<Map<String, dynamic>> listbanner =
        await DataUtils.getIndexTopSwipperBanners(context);

    if (listbanner.length > 0) {
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
      var cartdemoInfo = Provider.of<CartsProvider>(context, listen: false);
      await cartdemoInfo.initcartdemo();
    }

    getmsgreaed();
    _futureBannerBuilderFuture = _getbannerdata();
    _getDeviceList();

    setState(() {});
  }

  bool _loading = false;
  void showLoadingDialog(String msg) async {
    setState(() {
      _loading = true;
    });
    await DialogUtils.showLoadingDialog(context, text: msg);
  }

  hideLoadingDialog() {
    if (_loading) {
      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
    }
  }

  Location? _location;
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
