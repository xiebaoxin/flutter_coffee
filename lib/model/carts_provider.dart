import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'cart.dart';
import '../views/cart/cartdata.dart';

class CartsProvider with ChangeNotifier {

  int _cartcount = 0;
  int get cartcount => _cartcount;

  Future setcartcount(int cartcount) async {
    _cartcount = cartcount;
    notifyListeners();
  }

//-------------------------------
//以下为购物车
  List<CartItemModel> _cartitems=List();
  List<CartItemModel> get cartitems=>_cartitems;

  int get itemsCount {
    return _cartitems.length;
  }

  bool get isAllchecked {
    return _cartitems.every((i) => i.isSelected);
  }

  switchAllCheck() {
    if (this.isAllchecked) {
      _cartitems.forEach((i) => i.isSelected = false);
    } else {
      _cartitems.forEach((i) => i.isSelected = true);
    }
    notifyListeners();
  }

  double get sumTotal {
    double total = 0;
    _cartitems.forEach((item) {
      if (item.isDeleted == false && item.isSelected == true) {
        total = item.price * item.count + total;
      }
    });
    return total;
  }

  //设置当前数量
  setCount(int index,int cnt) {
    _cartitems[index].count = cnt;
    _cartitems[index].buyLimit -= cnt;
    notifyListeners();
  }

  addCount(int index) {
    _cartitems[index].count +=  1;
    notifyListeners();
  }


  downCount(int index) {
    _cartitems[index].count -= 1;
    notifyListeners();
  }

  removeItem(index) {
        _cartitems.removeAt(index);
       /* if(index==0){
          _cartitems=List();
        }else{
          _cartitems[index].count =0;
          _cartitems[index].isDeleted = true;
        }*/

        notifyListeners();

  }

  switchSelect(i) {
    _cartitems[i].isSelected = !_cartitems[i].isSelected;
    notifyListeners();

  }

  get totalCount {
    int count = 0;
    _cartitems.forEach((item) {
      if (item.isDeleted == false && item.isSelected == true) {
        count = item.count + count;
      }
    });
    return count;
  }


  void addtocart(context,Map<String, dynamic> params) {
    CartItemModel item=CartItemModel.fromJson((params));
      _cartitems.add(item);
      notifyListeners();
  }

void initcartdemo(){
  _cartitems=List();
  cartData.forEach((element) {
    CartItemModel item=CartItemModel.fromJson((element));
    _cartitems.add(item);
  });
  notifyListeners();
}


}
