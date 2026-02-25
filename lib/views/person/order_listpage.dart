import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/loading_gif.dart';
import '../../constants/config.dart';
import '../../utils/dataUtils.dart';
import '../../utils/utils.dart';
import '../../views/comm//gotopay.dart';
import '../../components/showimage.dart';

class Order_ListPage extends StatefulWidget {
  final String type;
  final String tname;

  Order_ListPage({Key? key, this.type = '', this.tname = ''}) : super(key: key);
  static const int PAGE_SIZE = 20;

  @override
  _Order_ListPageState createState() => _Order_ListPageState();
}

class _Order_ListPageState extends State<Order_ListPage> {
  List<dynamic> _items = [];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final newItems = await DataUtils.getOrderByUserIdPage(
          context, widget.type, _page, pagesize: Order_ListPage.PAGE_SIZE);
      setState(() {
        if (newItems == null || newItems.isEmpty) {
          _hasMore = false;
        } else {
          _items.addAll(newItems);
          _page++;
        }
      });
    } catch (e) {
      // ignore
    }
    _isLoading = false;
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
    });
    await _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: _items.isEmpty && !_hasMore
          ? Center(child: Text('没有数据哦'))
          : _items.isEmpty
              ? Center(child: Loading())
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _items.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _items.length) {
                      return Center(child: Loading());
                    }
                    return _itemBuilder(context, _items[index], index);
                  },
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
                child: OutlinedButton(
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
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: KfontConstant.littleBonStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("￥：${goods['PRICE']}",
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
