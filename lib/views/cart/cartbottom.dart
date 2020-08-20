import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../model/cart.dart';
import 'package:provider/provider.dart';
import '../../model/carts_provider.dart';
import 'cart.dart';
//import 'buygoods_page.dart';

class _TotalWidget extends StatefulWidget {
  final double totalPrice;
  _TotalWidget({Key key, this.totalPrice}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<_TotalWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;
  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween(begin: 0, end: widget.totalPrice).animate(_controller);
    _controller.forward();
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(_TotalWidget oldWidget) {
    animation = Tween(begin: oldWidget.totalPrice, end: widget.totalPrice)
        .animate(_controller);
    _controller.forward(from: 0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  RichText(
          text: TextSpan(
              text:  "合计:  ",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: widget.totalPrice.toStringAsFixed(2))
              ]),
        );
  }
}

class CartBottomWidget extends StatefulWidget{
  final int store_id;
  CartBottomWidget({this.store_id=0});
  @override
  State<StatefulWidget> createState() => CartBottomWidgetState();
}

class CartBottomWidgetState extends State<CartBottomWidget>{

  @override
  Widget build(BuildContext context) {
    // this.context = context;
    return Consumer<CartsProvider>(
        builder: (context, CartsProvider provider, _) {
      List<CartItemModel> cartlist=provider.cartitems;
      double total=0.0;
      int sumcount=0;
      cartlist.forEach((item){
          if(widget.store_id==0 || item.storeId==widget.store_id){
            sumcount+=item.count;
            total += item.price * item.count;
          }
      });

      return Container(
        height: 45,
        decoration: BoxDecoration(
            color: Color(0x2FFFFFFF),
            border: Border(

                top: BorderSide(color: Colors.grey,
                    width: 1))),
        padding: EdgeInsets.only(left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                      onTap: (){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (BuildContext context) {
                              return  Cart(store_id: widget.store_id,);
                            }));
                        },
                      child: Container(
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.shopping_cart),
                                ),
                              ),
                              Positioned(
                                child: Visibility(
                                    visible: sumcount > 0,
                                    child: Container(
                                      width: 16,
                                      height: 16,
//                      padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        border: Border.all(width: 0.5, color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.topCenter,
                                      child: Center(
                                        child: Text(
                                          sumcount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ))),
                  Expanded(
                    child: _TotalWidget(
                      totalPrice: total,
                    ),
                  )
                ],
              ),
            ),
//            去结算
            InkWell(
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10,right:8),
                  width: 80,
                  height: 35,
                  decoration: new BoxDecoration(
                    color: Color(0xFFfe5400),
                    border: null,
                    gradient:
                    const LinearGradient(
                        colors:[Colors.orange,Color(0xFFfe5400)]),
                    borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                  ),
                  child: Text(
                    '支付',
                    style: TextStyle(color: Colors.white),
                  )),
              onTap: () async {

          /*        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoodsBuyPage(store_id: widget.store_id,),//CartsBuyPage(),
                      ));*/
//
              },
            )
          ],
        ),
      );
    });
  }


}
