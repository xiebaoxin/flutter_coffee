import 'package:flutter/material.dart';
import '../../globleConfig.dart';
import 'cart_list.dart';
import 'cartbottom.dart';
import '../../model/cart.dart';
import '../../globleConfig.dart';
import '../../routers/application.dart';

class Cart extends StatefulWidget {
  final ishome;
  final store_id;
  Cart({this.ishome=false,this.store_id});
  @override
  State<StatefulWidget> createState() => CartState();
}

class CartState extends State<Cart> {
  @override
  void initState() {
     super.initState();
  }
  @override
  void dispose() {
    //重新整理更新购物车
    super.dispose();
  }


  @override
  void didUpdateWidget( oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _strollCtrl = ScrollController();
bool _isedit=false;
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFFFFFFF),
    child: SafeArea(
    bottom: true,
    top: false,

    child:Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        key: _scaffoldKey,
        appBar:  AppBar(
//          backgroundColor: GlobalConfig.mainColor,
          title: new Text('购物车'/*,style: TextStyle(color: Color(0xFFFFFFFF)),*/),
          centerTitle: true,
          leading: Visibility(
              visible: !widget.ishome,
              child: IconButton(icon: Icon(Icons.arrow_back_ios,), onPressed: (){
              Navigator.of(context).pop();
              })),

         /* actions: <Widget>[Center(
            child: Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: InkWell(child: Text(_isedit?"取消编辑":"编辑"),onTap: (){
                setState(() {
                  _isedit=!_isedit;
                });
              },),
            ),
          )],*/
        ),
        body:
        Container(
          color: Color(0xafeeeeee),
          child:
              CartListWidget(isedit: _isedit,)
            ,
        ),
      bottomNavigationBar:  CartBottomWidget(),
    )
    ));
;
  }

  Widget buildtopbar(String title) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      alignment: Alignment.center,
      height: statusBarHeight + Klength.topBarHeight,
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Color(0xFFe1e1e1), width: 1))),
      child:
      Text(title, style: TextStyle(color: Color(0xFF313131), fontSize: 18)),
    );
  }
}

