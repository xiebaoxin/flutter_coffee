import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../routers/application.dart';
import '../../components/loading_gif.dart';
import '../../globleConfig.dart';

class GoodsListItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final int type; //0 横向列表元素 1方块列表元素
  GoodsListItem(this.item, {this.type = 0});

  @override
  Widget build(BuildContext context) {

    double point_rate = 0.1;

    if (type == 1)
      return buildtype1(context, point_rate);
    else if (type == 2)
      return buildtype2(context, point_rate);
    else
      return buildtype0(context, point_rate);
  }

  Widget buildtype0(BuildContext context, double point_rate) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
//          Application.goodsDetail(context, item['goods_id'].toString());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) => Container(
                  height: 75,
                  width: 75,
                  child: Image.asset(
                    'images/logo-no.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                ),
                placeholder: (context, url) => Loading(),
                imageUrl: item[
                    'pic_url'], //"http://testapp.hukabao.com:8008/public/upload/goods/thumb/236/goods_thumb_236_0_400_400.png",//
                width: 85,
                height: 85,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item['title'],
                      maxLines: 2,
                      softWrap:
                          true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                      overflow: TextOverflow.ellipsis,
                      style: KfontConstant.littleStyle),
                  SizedBox(
                    width: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /* Container(
                                    child: Text(
                                      '市场价：${item['market_price']}',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16),
                                          color: KColorConstant.themeColor),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    margin: EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: KColorConstant.themeColor)),
                                  )*/
                          Text('￥${item['shop_price']}',
                              style: KfontConstant.priceStyle),
                          SizedBox(
                            height: 2,
                          ),
                          /*   Text(
                                '获得:${(double.tryParse(item['shop_price']) * _point_rate).toStringAsFixed(2)}TML',
                                style: TextStyle(
                                  fontSize:12,
                                  color: Colors.black45,
                                  decoration: TextDecoration.none,
                                ),
                              ),*/
                        ],
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          height: 30,
                          child: RaisedButton(
                              color: KColorConstant.mainColor,
                              elevation: 2,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '立即购买',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
//                              onPressed: () {
//                                Application.goodsDetail(
//                                    context, item['goods_id'].toString());
//                              }
                              )),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildtype1(BuildContext context, double point_rate) {
    double deviceWidth = MediaQuery.of(context).size.width;

    var bgColor = Color(0xFFFFFFFF); // string2Color(i.bgColor);
    double itemWidth = (deviceWidth / 2) - 1; // deviceWidth * 100 / 360;
    ShapeBorder _shape = const RoundedRectangleBorder(
      side: BorderSide(color: Color.fromRGBO(238, 238, 238, 0.5)),
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
        padding: EdgeInsets.only(top: 2, bottom: 2),
        color: bgColor,
        child: InkWell(
          onTap: () {
//            Application.goodsDetail(context, item['goods_id'].toString());
          },
          child: Card(
            // This ensures that the Card's children are clipped correctly.
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0),
            shape: _shape, //,
            elevation: 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0 / 1.0,
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Container(
                      width: itemWidth,
                      height: itemWidth,
                      child: Image.asset(
                        'images/logo-no.png',
                        height: 15,
                        width: 15,
                        fit: BoxFit.fill,
                      ),
                    ),
                    placeholder: (context, url) => Loading(),
                    imageUrl: item[
                        'pic_url'], //"http://testapp.hukabao.com:8008/public/upload/goods/thumb/236/goods_thumb_236_0_400_400.png",//
                    width: itemWidth,
                    height: itemWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                  child: Text(
                    item['title'],
                    maxLines: 2,
                    softWrap:
                        true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                    overflow: TextOverflow
                        .ellipsis, //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                    style: KfontConstant.littleselectedStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 2, 5, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('￥${item['shop_price']}',
                          style: KfontConstant.defaultStyle),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${(double.tryParse(item['sale_num'].toString())).toStringAsFixed(0)}人付款',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                  child:
                  Text(
                      item['plan_getask'].toString().isEmpty?
                    '获得：${(double.tryParse(item['shop_price']) * (double.tryParse(item['jtrate']))).toStringAsFixed(4)}TML':
                    '获得：${item['plan_getask'].toString() }',

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildtype2(BuildContext context, double point_rate) {
    return Container(
      padding: EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
//          Application.goodsDetail(context, item['goods_id'].toString());
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 8),
                  width: 250,
                  child: Text(item['title'],
                      maxLines: 2,
                      softWrap:
                          true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Container(
                      height: 45,
                      width: 45,
                      child: Image.asset(
                        'images/logo-no.png',
                        height: 30,
                        width: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                    placeholder: (context, url) => Loading(),
                    imageUrl: item[
                        'pic_url'], //"http://testapp.hukabao.com:8008/public/upload/goods/thumb/236/goods_thumb_236_0_400_400.png",//
                    width: 65,
                    height: 65,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
