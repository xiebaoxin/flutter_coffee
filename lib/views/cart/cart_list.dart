import 'package:flutter/material.dart';
import '../../utils/DialogUtils.dart';
import 'package:provider/provider.dart';
import '../../model/carts_provider.dart';
import '../../model/cart.dart';
import '../../constants/color.dart';
import 'cartItem.dart';


class CartListWidget extends StatefulWidget {
final bool isedit;
CartListWidget({this.isedit=false});
  @override
  State<StatefulWidget> createState() => CartListWidgetState();
  }

  class CartListWidgetState extends State<CartListWidget> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Consumer<CartsProvider>(
        builder: (context, CartsProvider model, _) {
      if(model.itemsCount==0)
        return Center(child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text("空空如也,快去购物吧"),
        ));
      else
      return Container(
          child:  ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: model.itemsCount,
//          itemExtent: 93,
          itemBuilder: (BuildContext context, int index) {
            CartItemModel item = model.cartitems[index];
            return
               Dismissible(
              resizeDuration: Duration(milliseconds: 100),
              key: Key(item.productName),
               confirmDismiss: (direction) async{
                if( await DialogUtils().showMyDialog(context, '是否确定要移除?')){
                await  model.removeItem(index);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("${item.productName}   成功移除"),
                    backgroundColor: KColorConstant.themeColor,
                    duration: Duration(seconds: 1),
                  ));
                }
              },
              background: Container(color: KColorConstant.themeColor,child: Center(child: Text("删除",style: TextStyle(color: Color(0xFFFFFFFF)),)),),
              child:
              Stack(
                children: <Widget>[
                  CartItemWidget(
                    model.cartitems[index],
                    addCount: (int i) {
                      model.addCount(i);
                    },
                    downCount: (int i) {
                      model.downCount(i);
                    },
                    index: index,
                    showtype: 1,
                    switchChaned: (i){ model.switchSelect(i);},
                  ),
                /*  Positioned(
                      bottom:0,
                      right: 15,
                      child: Visibility(
                      visible: widget.isedit,
                      child: Container(
                        width: 32,
                        child: IconButton(icon: Icon(Icons.delete_forever,size: 20,color: Color(0xff888888),), onPressed: () async{
                          if( await DialogUtils().showMyDialog(context, '是否确定要移除?')){
                            final model = GlobleModel().of(context);
                            await  model.removeItem(index);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(" 成功移除"),
                              backgroundColor: KColorConstant.themeColor,
                              duration: Duration(seconds: 1),
                            ));
                          }
                        }),
                      )))*/

                ],
              )
            )
            ;
          },

      ));
    }) ;
  }

}
