import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'order_listpage.dart';

class OrderListPage extends StatefulWidget {
  OrderListPage({Key key, this.title = '我的订单', this.type = 0}) : super(key: key);

  final int type;
  final String title;

  @override
  OrderListPageState createState() => OrderListPageState();
}
TabController _tabController;

class OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
//  1=待取货，0=待付款，2=已通知咖啡机，3=已完成，4=已退款，5=全部
  List<Map<String, dynamic>> _tabs = [
    {
      'text': "全部",
      'type': "5",
    },
    {
      'text': "待付款",
      'type': "0",
    },
    {
      'text': "待取货",
      'type': "1",
    },
/*    {
      'text': "取货异常",
      'type': "2",
    }
    ,*/
    {
      'text': "已完成",
      'type': "3",
    },
    {
      'text': "已退款",
      'type': "4",
    },
    {
      'text': "已评价",
      'type': "6",
    }
  ];

  @override
  void initState() {

    super.initState();
    _tabController = new TabController(length: _tabs.length,vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: new AppBar(
        title: Text("我的订单"),
        centerTitle: true,
        bottom: new TabBar(
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 9),
          labelStyle: TextStyle(fontSize: 14,
              fontWeight: FontWeight.bold),
          unselectedLabelColor:
          Colors.white54,
          indicatorColor: Theme
              .of(context)
              .primaryColor,
          indicatorWeight: 2.0,
          //迭代items 并生成Tab对象
          tabs: _tabs.map((Map<String, dynamic> item) {
            return new Tab(
              text: item['text'],
//                      icon: new Icon(item.icon),
            );
          }).toList(),

        ),
      ),
      body: new TabBarView(
          controller: _tabController,
          children: _tabs.map((Map<String, dynamic> item) {
            return Order_ListPage(type:item['type']);
          }).toList()),
    );

  }

}
