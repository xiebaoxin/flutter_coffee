import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../components/fiexdAppbar.dart';

class NewsList extends StatefulWidget {
  final int pid;
  final String pname;
  NewsList({Key key, this.pid = 0, this.pname = '新闻'}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewsListPageState();
}

class NewsListPageState extends State<NewsList>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;
  ScrollController _scrollController = ScrollController(); //listview的控制器

  List<Map<String, dynamic>> _tabs = [
    {
      'text': "推荐",
      'cat_id': 0,
    }
  ];
  List<Map<String, dynamic>> _CategoryItems = [];
  Future<List<Map<String, dynamic>>> _initCatsDatelist(context) async {
    Map<String, dynamic> response = {};
/*    await HttpUtils.dioappi(
        'Shop/categoryList/pid/${widget.pid.toString()}', {},
        withToken: true, context: context);*/

    var cateliest = response["list"];
    if (cateliest != null) {
      cateliest.forEach((ele) {
        if (ele.isNotEmpty) {
          _CategoryItems.add(ele);
        }
      });
//        print(_CategoryItems);
      _tabs = _CategoryItems.map((item) {
        return {
          'text': item['cat_name'],
          'cat_id': item['cat_id'],
        };
      }).toList();

      setState(() {
        _tabs.insert(0, {
          'text': "全部",
          'cat_id': widget.pid,
        });
      });
    }
  }

  int _tabIndex = 0;
  @override
  void initState() {
    _initCatsDatelist(context);
    super.initState();

    _tabController =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _headersm = true;//true为白底false为绿底

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: _headersm?SystemUiOverlayStyle.dark:SystemUiOverlayStyle.light,
        child: Material(

            child: DefaultTabController(
                length: _tabs.length,
                initialIndex: 0,
                child: Scaffold(

//                  backgroundColor: _headersm?Color(0xFFFFFFFF):KColorConstant.themeColor,
                  appBar:
                  FiexdAppbar(
                    contentHeight: 90.0,
                    contentChild: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 5, 2),
                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color:  _headersm?Colors.black54:Color(0xFFFFFFFF),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              Expanded(
                                  child: Container(
                                width: 200,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 0, bottom: 0),
                                    child: Center(
                                      child: Text(
                                        widget.pname,
                                        style: TextStyle(
                                            fontSize: 18,fontWeight: FontWeight.bold,
                                            color:  _headersm?Colors.black:Colors.white,
                                            letterSpacing: 2),
                                      ),
                                    )),
                              )),
                              SizedBox(
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _headersm,
                          child: Divider(height: 1,),),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TabBar(
                            indicatorWeight: 2,
                            labelPadding: EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
//                            indicatorColor: _headersm
//                                ?
//                                 KColorConstant.themeColor:Color(0xFFFFFFFF),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
//                            labelColor: _headersm
//                                ? KColorConstant.themeColor
//                                : Color(0xFFFFFFFF),
                            unselectedLabelColor:_headersm
                                ? Colors.black87:Colors.white70,
                            labelStyle: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                            unselectedLabelStyle: TextStyle(
                                letterSpacing: 1.8,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                            tabs: _tabs
                                .map((i) => Container(
                                      height: 30,
                                      child: Tab(
                                        text: i['text'],
                                      ),
                                    ))
                                .toList(),
                            onTap: (index){
                            setState(() {
                              _tabIndex=index;
                            });
                      },
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Container(
                    color: Color(0xFFFFFFFF),
                    child: IndexedStack(
                      children: _tabs.map((v) {
                        return Text("dfsfdsf");
//                        return NewsListPage(catid: v['cat_id'].toString());
                      }).toList(),
                      index: _tabIndex,
                    ),
                  ),
                ))));
  }
}
