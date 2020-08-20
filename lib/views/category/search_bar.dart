import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SearchBar extends StatefulWidget {
@override
State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 45,
      margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color:Colors.amber,width: 1.0))),
      padding: EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Container(
          height: 37,
          padding: EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.center,
          color: Colors.amber,//KColorConstant.searchBarBgColor,
          child:
          Row(
            children: <Widget>[
            Icon(Icons.search,size: 17,),
            Container(
              margin: EdgeInsets.only(left: 5) ,
              child: Form(
                autovalidate: true,
                child:Container(
                  width: 260,
                  child: TextField(
                    controller: controller ,
                    onSubmitted: (s) {
                      print(s);
                    }, // 键盘回车键
                    cursorWidth: 1.5,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        hintText: "susuodsfsf",
                        hintStyle: TextStyle(fontSize: 12,color: Colors.amber),
                        border: InputBorder.none),
                  ),
                )),
            ),
           /*   SearchTopBarActionWidget(
                onActionTap: () => goSearchList(context,controller.text),
              )
*/


            ],
          ),
        ),
      )
    ;
  }


  goSearchList(context,String keyWord) {
    if (keyWord.isNotEmpty) {
      Navigator.push(context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return ;//SearchResultListPage(keyWord);
          }));
    }
  }
}
