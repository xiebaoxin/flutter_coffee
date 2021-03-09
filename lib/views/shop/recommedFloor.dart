import 'package:flutter/material.dart';
import '../../globleConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/loading_gif.dart';
import '../../routers/application.dart';

class RecommendFloor extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  RecommendFloor(this.data);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    var bgColor = Color(0xFFFFFFFF); // string2Color(i.bgColor);
//    ShapeBorder _shape = GlobalConfig.cardBorderRadius;

    List<Widget> listWidgets = data.map((i) {
      return Container(
          padding: EdgeInsets.all(0),
          child: InkWell(
            onTap: () {
              print(i);
           /*   if (i['item_id'] != null) {
                if (i['item_id'] > 0)
                  Application.goodsDetail(context, i['goods_id'].toString(),
                      itemId: i['item_id']);
                else
                  Application.goodsDetail(context, i['goods_id'].toString());
              } else
                Application.goodsDetail(context, i['goods_id'].toString());*/
            },
            child: Container(
              height: 160,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                color: bgColor,
//                borderRadius:  BorderRadius.vertical( top: Radius.circular(2)),
                border: Border(
                    right: BorderSide(
                        color: KColorConstant.cartDisableColor, width: 1.0)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => Container(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'images/logo-no.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        placeholder: (context, url) => Loading(),
                        imageUrl: i[
                            'pic_url'], //"http://testapp.hukabao.com:8008/public/upload/goods/thumb/236/goods_thumb_236_0_400_400.png",//
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            i['title'],
                            maxLines: 2,
                            softWrap:
                                true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                            overflow: TextOverflow
                                .ellipsis, //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                            style: KfontConstant.littleStyle,
                          ),
                          Text('￥${i['shop_price']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: KColorConstant.priceColor,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    }).toList();

    return Container(
        width: deviceWidth,
        color: Colors.transparent,
        height: 168,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView(
            children: listWidgets,
            itemExtent: 101,
            scrollDirection: Axis.horizontal,
          ),
        ));
  }
}
