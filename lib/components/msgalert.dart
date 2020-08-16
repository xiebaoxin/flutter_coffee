import 'package:flutter/material.dart';
class MessageAlert extends StatelessWidget {
  final String msg;
  MessageAlert({this.msg='异常'});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x0a0000000),
      body: SafeArea(
//          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Container(
              decoration: new BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all( Radius.circular(20)),
                  border:
                  null // Border.all(   width: 1.0, color: Colors.green),
              ),
              height: 380,
              child:
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      msg,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20,),
                    FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("确认"))
                  ],
                ),
              )

            ),
          )),
    );
  }


}
