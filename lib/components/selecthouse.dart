import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/dataUtils.dart';
import '../utils/DialogUtils.dart';

class SelectHouse extends StatefulWidget {
  final List<Map<String, dynamic>> itemList;
  final callback;
  SelectHouse(this.itemList, this.callback);

  @override
  _HouseListState createState() => _HouseListState();
}

class _HouseListState extends State<SelectHouse> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
//  ScrollController _scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    num length = widget.itemList.length;
    return Scaffold(
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
                    color:
                    Color(0xffffffff), //Color.fromRGBO(253, 224, 168, 1),
//          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                    border: null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 360,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                                title: Text("房屋列表"),
                                trailing: Icon(Icons.close),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                            Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: length,
//        separatorBuilder: (BuildContext context, int index) => new Divider(),  // 添加分割线
                                itemBuilder: (BuildContext context, int index) {
                                  return _addressItemCard(index);
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                ))));

  }

  Widget _addressItemCard(int index) {
    Map<String, dynamic> address = widget.itemList[index];
    String uninanme = address['COMMUNITYNAME'] +
        address['BLOCKNAME'] +
        address['CELLNAME'] +
        address['UNITNO'];
    return Container(
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Container(
          color: Color(0xFFFFFFFF),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Row(
                  children: <Widget>[
                    Text("${address['UNITNO']}"),
                    Visibility(
                        visible: address['STATE'] == 'P',
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '审核中…',
                            style: TextStyle(color: Colors.red),
                          ),
                        ))
                  ],
                ),
                subtitle: Text(uninanme),
                onTap: ()async{
                  if(address['STATE'] == 'P')
                    {
                      await DialogUtils.showToastDialog(context, "房屋无效");
                    }
                  else{
                    widget.callback(index,uninanme,address);
                    Navigator.of(context).pop();
                  }

                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
