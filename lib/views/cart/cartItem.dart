import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/loading_gif.dart';
import '../../components/showimage.dart';
import '../../model/cart.dart';
import '../../utils/utils.dart';
import '../../globleConfig.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel data;
  final int index;
  final Function(int i) switchChaned;
  final Function(int i) addCount;
  final Function(int i) downCount;
final bool readonly;
final int showtype;
  CartItemWidget(this.data,
      {this.switchChaned, this.index, this.addCount, this.downCount,this.readonly=false,this.showtype=0});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, right: 8, left: 8),
      child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[

                    Visibility(
                      visible:  showtype==0 && !readonly ,
                      child:  InkWell(
                          onTap: () => switchChaned(index),
                          child: Icon(
                            data.isSelected
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: KColorConstant.themeColor,
                          )),
                    )
                   ,
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 8),
                      child:
                      ShowNetImage(
                        servpic(data
                            .imageUrl),
                        height:60,
                        width: 60,
                        tapnull: true,
                      ),
                    ),
                    Expanded(child: Container(
                      height: 60,
                      padding: const EdgeInsets.only(left:5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              child: Text(data.productName,
                                  maxLines: 2,
                                  softWrap:
                                  true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data.attr,
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),

                                  !readonly?
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => data.count > 1
                                            ? downCount(index)
                                            : false,
                                        child: Icon(Icons.remove_circle,
                                            size: 20,
                                            color: _getRemovebuttonColor()),
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:5.0,right: 5),
                                            child: Text(
                                              data.count.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                      GestureDetector(
                                        onTap: () => data.count < data.buyLimit
                                            ? addCount(index)
                                            : false,
                                        child:  Icon(Icons.add_circle,
                                            size: 20,
                                            color: _getAddbuttonColor()),
                                      ),
                                    ],
                                  ) :
                                  Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            data.count.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: KColorConstant.themeColor),
                                          ),
                                          Text(
                                            "件",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,),
                                          ),
                                        ],
                                      )),

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              child:   Container(
                                child: Row(
                                  children: [
                                    Text(
                                      '￥',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: KColorConstant.themeColor),
                                    ),
                                    Text(
                                      data.price.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: KColorConstant.themeColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Divider()
            ],
          ),
        ),
    );
  }

  Color _getRemovebuttonColor() {
    return data.count > 0
        ? KColorConstant.cartItemChangenumBtColor
        : KColorConstant.cartDisableColor;
  }

  _getAddbuttonColor() {
    return data.count >= 1 //(this.readonly?1000: data.buyLimit)
        ? KColorConstant.cartItemChangenumBtColor
        : KColorConstant.cartDisableColor;
  }
}
