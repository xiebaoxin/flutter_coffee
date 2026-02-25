import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import '../../utils/HttpUtils.dart';
import '../../constants/config.dart';
// import '../index.dart'; // file does not exist
import 'package:flutter/cupertino.dart';
import 'searchlist.dart';
import 'search/hotSug.dart';
import 'search/recomend.dart';
import 'search/topbar.dart';

class SearchPage extends StatefulWidget {
  final bool ishome;
  SearchPage({this.ishome=false});
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List hotWords = [];
  List<String> recomendWords = [];
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: KColorConstant.searchAppBarBgColor,
          leading:widget.ishome?SizedBox(width: 5,): SearchTopBarLeadingWidget(),
          actions: <Widget>[
            SearchTopBarActionWidget(
              onActionTap: () => goSearchList(controller.text),
            )
          ],
          elevation: 0,
          titleSpacing: 0,
          title: SearchTopBarTitleWidget(
            seachTxtChanged: seachTxtChanged,
            controller: controller,
          )),
      body: recomendWords.length == 0
          ? HotSugWidget(hotWords:hotWords,goSearchList: goSearchList,)
          : RecomendListWidget(recomendWords, onItemTap: goSearchList),
    );
  }

  void initData() async {
    // HttpUtils.dioappi does not exist; commented out
    // var response =await HttpUtils.dioappi(
    //     "Shop/getHotKeys", {}, context: context);
    // var querys =  response['result'] as List;

    setState(() {
      // hotWords = querys;
    });
  }

  onSearchBtTap() {
    if (controller.text.isNotEmpty) {
      goSearchList(controller.text);
    }
  }

  void seachTxtChanged(String q) async {
    var result =[];
    recomendWords = result.map((dynamic i) {
      List item = i as List;
      return item[0] as String;
    }).toList();
    setState(() {});
  }

  goSearchList(String keyWord) {
    if (keyWord.isNotEmpty) {
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return SearchResultListPage(keyWord);
      }));
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
}
