import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../globleConfig.dart';

class Addplus extends StatefulWidget {
  final int count;
  final int max;
  final Function callback;
  Addplus({this.count = 1, this.max = 1000, this.callback});

  @override
  AddPlusState createState() => AddPlusState();
}

class AddPlusState extends State<Addplus> {
  TextEditingController _countCtrl = TextEditingController.fromValue(TextEditingValue(
    // 设置内容
      text: "1",
      // 保持光标在最后
      selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: 1)))
  );
  FocusNode _focusNode = FocusNode();

  int _count;
  @override
  Widget build(BuildContext context) {
    _countCtrl.text = _count.toString();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _focusNode.unfocus();
              if (_count > 0) {
                _count -= 1;
                widget.callback(_count);
              }
            });
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                /* borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  bottomLeft: Radius.circular(3.0),
                ),*/
                border: _getRemoveBtBorder()),
            child: Icon(
              Icons.remove,
              color: _getRemovebuttonColor(),
              size: 10,
            ),
          ),
        ),
        Expanded(child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(
                  color: KColorConstant.txtFontColor, width: 1)),
          child: CupertinoTextField(
            controller: _countCtrl,
            focusNode: _focusNode,
//            autofocus: true,
//            textAlign: TextAlign.right,
//            prefix: Text(_count.toString(),style: TextStyle(color: KColorConstant.mainColor)),
            keyboardType: TextInputType.number,
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.0, color: CupertinoColors.inactiveGray)),
            ),
            /*   onEditingComplete: () {
              setState(() {
                _count = int.tryParse(_countCtrl.text);
                if (_count > 0) {
                  widget.callback(_count);
                }
              });
            },
               onSubmitted: (value) {
                _count=int.tryParse(value);
                if (_count > 0) {
                  widget.callback(_count);
                }
            },
           onChanged: (value) {
             setState(() {
               _count=int.tryParse(value);
               if (_count > 0) {
                 widget.callback(_count);
               }
             });

            }, */
          ),
        )),
        GestureDetector(
          onTap: () {
            {
              _focusNode.unfocus();
              setState(() {
                if (_count > 0) {
                  _count += 1;
                  widget.callback(_count);
                }
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            decoration: BoxDecoration(border: _getAddBtBorder()),
            child: Icon(
              Icons.add,
              color: _getAddbuttonColor(),
              size: 10,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _count = widget.count;
    // TODO: implement initState
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print("hasFocus!!!lost");
        _count = int.tryParse(_countCtrl.text);
        if (_count >= 0) {
          widget.callback(_count);
        }
      }else{
        print("hasFocus!!!on");
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Color _getRemovebuttonColor() {
    return _count > 0
        ? KColorConstant.cartItemChangenumBtColor
        : KColorConstant.cartDisableColor;
  }

  Border _getRemoveBtBorder() {
    return Border(
        bottom: BorderSide(width: 1, color: _getRemovebuttonColor()),
        top: BorderSide(width: 1, color: _getRemovebuttonColor()),
        left: BorderSide(width: 1, color: _getRemovebuttonColor()));
  }

  Border _getAddBtBorder() {
    return Border(
        bottom: BorderSide(width: 1, color: _getAddbuttonColor()),
        top: BorderSide(width: 1, color: _getAddbuttonColor()),
        right: BorderSide(width: 1, color: _getAddbuttonColor()));
  }

  _getAddbuttonColor() {
    return _count >= widget.max
        ? KColorConstant.cartDisableColor
        : KColorConstant.cartItemChangenumBtColor;
  }
}
