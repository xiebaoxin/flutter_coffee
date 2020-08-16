import 'package:flutter/material.dart';
class MyPicker extends StatefulWidget {
  final String title;
  final List<dynamic> datalist;
  final bool single;//true单选 字符串
  final String datakey,valuekey;
  final callback;
  MyPicker(this.title,this.datalist,this.callback,{this.datakey="",this.valuekey="",this.single=false});
  
  @override
  _MyPickerState createState() => _MyPickerState();
}

class _MyPickerState extends State<MyPicker> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0x0a0000000),
        key: _scaffoldkey,
        body: SafeArea(
            bottom: false,
            child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xffffffff),//Color.fromRGBO(253, 224, 168, 1),
//          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                      border: null,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 360,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                    title: Text(widget.title),
                                    trailing: Icon(Icons.close),
                                    onTap: () {
//                              ss=null;
                                      Navigator.pop(context);
                                    }),
                                Divider(),
                                Expanded(child: _getBody(),)
                                ,
                              ],
                            )
                        ))))));
  }
  Widget _getBody() {
    var length = widget.datalist.length;
    return widget.datalist.isNotEmpty
        ? ListView.builder(
      itemCount: length,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title:Text(widget.single? widget.datalist[index]:widget.datalist[index][widget.datakey]),
          onTap: (){
            if(widget.single)
              widget.callback(widget.datalist[index],widget.datalist[index]);
            else
              widget.callback(widget.datalist[index][widget.datakey],widget.datalist[index][widget.valuekey].toString());
            Navigator.of(context).pop();
          },
        );

      },
    )
        : Center(
      child: Text("没有可供选择数据"),
    );
  }

}
