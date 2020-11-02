import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import '../../components/loading_gif.dart';
import '../../constants/config.dart';
import '../../utils/dataUtils.dart';
import '../../utils/utils.dart';
import '../../views/comm//gotopay.dart';
import '../../components/showimage.dart';

class Order_ListPage extends StatelessWidget {

  final String type;
  final String tname;

  Order_ListPage({Key key, this.type = '', this.tname = ''}) : super(key: key);
  static const int PAGE_SIZE = 20;

  @override
  Widget build(BuildContext context) {
    
    return _getBody(context);

  }

  Widget _getBody(context) {
    final pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) => DataUtils.getOrderByUserIdPage(context, this.type,pageIndex,pagesize: PAGE_SIZE)//getPosts(context,this.type,pageIndex, PAGE_SIZE)
    );

    return RefreshIndicator(
      onRefresh: () async {
        pageLoadController.reset();
        await Future.value({});
      },
      child: PagewiseListView(
        itemBuilder: this._itemBuilder,
        noItemsFoundBuilder: (context) {
          return Text('没有数据哦');
        },
        loadingBuilder: (context) {
          return Loading();
        },
        pageLoadController: pageLoadController,
      ),
    );
  }


  Widget _itemBuilder(context, dynamic item, _) {
   Map<String, dynamic> device=item['device'];
    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 2),
      child: item != null
          ?
      Card(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "编号: ",
                    style:KfontConstant.littleStyle,
                  ),
                  Text(
                    "${item['orderId']}",
                    style:KfontConstant.littleStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: ListTile(
                leading:  ShowNetImage(
                  servpic(item['image']),
                  height:60,
                  width: 60,
                  tapnull: true,
                ),

                title:Text(
                  "${item['coffeeName']}",
                  style: TextStyle(color: Colors.red),
                ) ,
subtitle: Column(
  children: [
    Row(
      children: <Widget>[
        Text(
          "喜好: ",
          style:KfontConstant.littleStyle,
        ),
        Text(
          " ${DataUtils.coffeesugarRule(item['sugarRule'])}",
          style:KfontConstant.littleStyle,
        ),
      ],
    ),
        Row(
      children: <Widget>[
        Text(
          "咖啡机: ",
          style:KfontConstant.littleStyle,
        ),
        Text(
          " ${device['name']}",
          style:KfontConstant.littleStyle,
        ),
      ],
    ),
  ],
),
                trailing: Text(
                  "${DataUtils.coffeeorderstatus(item['status'])}",
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                ),

              ),
            ),
            Divider(),
           /* Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: ods.map((v) {
                    return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: _orderTitle(v),
                        ));
                  }).toList(),
                )),*/
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Row(
                        children: <Widget>[
                          Visibility(visible: item['pickUpCode']!=null,
                          child: Row(
                            children: [
                              Text(
                                "取货码:",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "${item['pickUpCode']}",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green),
                              ),
                            ],
                          ) ,)
                         ,
                          SizedBox(width: 10,),
                          Row(
                            children: [
                              Text(
                                "￥${item['productMoney'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "${DataUtils.coffeePayType(item['orderType'])}",
                                  style: TextStyle(fontSize: 11,color: Colors.black38),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    alignment: FractionalOffset.bottomRight,
                  ),
                ],
              ),
            ),
          /*
            Divider(
              height: 1,
            ),
            Visibility(
                visible: item != null,
                child: _orderBottomBar(context,item)),*/
          ],
        ),
      )
          : Divider(),
    );
  }


  _orderBottomBar(context,Map<String, dynamic> order) {
    return Column(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            Visibility(
                visible: order['STATE'] == "NEW",
                child: OutlineButton(
                  child: const Text('立即付款'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GoToPayPage(order['ORDERNUM'],scean: "OTO",data:  order,),
                      ),
                    );
                  },
                )),
            /*  Visibility(
                visible: order['cancel_btn'] == 1 &&
                    (order['pay_status'] == 0 ||
                        (order['pay_status'] == 1 &&
                            order['pay_time'] >
                                (DateTime.now().millisecondsSinceEpoch / 1000 -
                                    7200))),
                child: OutlineButton(
                  child: const Text('取消订单'),
                  onPressed: () {
                    if (order['pay_status'] == 0)
                      HttpUtils.dioappi(
                              "Order/cancel_order/id/" +
                                  order['order_id'].toString(),
                              {},
                              context: context,
                              withToken: true)
                          .then((response) async {
                        await DataUtils.freshUserinfo(context);
                        final model = globleModel().of(context);
                        model.freshOrderCounts(context);
                        await DialogUtils.showToastDialog(
                            context, response['msg'].toString());
                        _page = 1;
                        _payLogList = List();
                        loadData();
                      });
                    else if (order['pay_status'] == 1) {
                      HttpUtils.dioappi('Order/record_refund_order',
                              {'order_id': order['order_id'].toString()},
                              context: context, withToken: true)
                          .then((response) async {
                        await DataUtils.freshUserinfo(context);
                        final model = globleModel().of(context);
                        model.freshOrderCounts(context);
                        await DialogUtils.showToastDialog(
                            context, response['msg'].toString());
                        _page = 1;
                        _payLogList = List();
                        loadData();
                      });
                    }
                  },
                )),
            Visibility(
              visible: (order['receive_btn'] == 1 && order['pay_status'] == 1),
              child: OutlineButton(
                child: const Text('确认收货'),
                onPressed: () {
                  HttpUtils.dioappi(
                          'Order/order_confirm/id/${order['order_id']}', {},
                          context: context, withToken: true)
                      .then((response) async {
                    await DataUtils.freshUserinfo(context);
                    final model = globleModel().of(context);
                    model.freshOrderCounts(context);
                    await DialogUtils.showToastDialog(
                        context, response['msg'].toString());
                    _page = 1;
                    _payLogList = List();
                    loadData();
                  });
                },
              ),
            ),
            Visibility(
                visible: (order['shipping_btn'] == 1 &&
                    order['shipping_name'] != ""),
                child: OutlineButton(
                  child: const Text('查看物流'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PayPage(order['order_sn'].toString()),
                      ),
                    );
                  },
                )),
            Visibility(
                visible: order['comment_btn'] == 1,
                child: OutlineButton(
                  child: const Text('我要评论'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CmtGoodsListPage(),
                      ),
                    );
                  },
                )),*/
          ],
        ),
      ],
    );
  }


  _orderTitle(Map<String, dynamic> goods) {
    return Container(
      padding: EdgeInsets.only(left:5.0,right: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text(
              "${goods['PRODNAME']}",
              maxLines: 2,
              softWrap: true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
              overflow: TextOverflow.ellipsis,
              style: KfontConstant.littleBonStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("￥：${goods['PRICE']}",//${goods['member_goods_price']}
                    style: TextStyle(fontSize: 12),
                  ),
                  Text("x${goods['COUNT'].toString()}",
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                ]),
          ),
          Divider()
        ],
      ),
    );
  }
}
