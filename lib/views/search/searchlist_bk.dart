import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../components/loading_gif.dart';
import '../../globleConfig.dart';
import '../goodsList.dart';
import '../shop/goods_list_item.dart';

class SearchResultListPage extends StatefulWidget {
  final String keyword;
  final String catname;
  final int catid;
  final int brand_id;
  final Map<String, dynamic> catitem;
  final bool showlist;
  final bool is_end;
  SearchResultListPage(this.keyword,
      {this.catid = 0,
      this.catname = '',
      this.brand_id = 0,
      this.catitem,
      this.showlist = false,
      this.is_end = false});

  @override
  State<StatefulWidget> createState() => SearchResultListState();
}

class SearchResultListState extends State<SearchResultListPage> {
  ScrollController scrollController = ScrollController(); //listview的控制器

  List itm = List();
  bool _price_sort = false, _selnum_sort = false;

  String _dropdownValue1 = '新品';
  String _dropdownValue2 = '筛选';

  String _is_new = '0', _sort = 'sort',_sort_asc='desc';

  @override
  Widget build(BuildContext context) {
    if (widget.is_end) {
      return SafeArea(
        child: Container(
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      value: _dropdownValue1,
                      items: <String>['新品', '推荐']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String v) {
                        setState(() {

                          _dropdownValue1 = v;
                          if (v == '新品')
                            _is_new = '1';
                          else
                            _is_new = '0';

                          redoseach();
                        });
                      },
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {

                          _price_sort = !_price_sort;
                          _sort = 'sales_sum';
                          _sort_asc=_price_sort?'asc':'desc';
                          redoseach();
                        });
                      },
                      textColor: Colors.black54,
                      child: Row(
                        children: <Widget>[
                          Text("价格"),
                          Icon(_price_sort
                              ? Icons.arrow_drop_up
                              : Icons.unfold_more,)
                        ],
                      )),
                  FlatButton(
                    textColor: Colors.black54,
                      onPressed: () {
                        setState(() {
                          _selnum_sort = !_selnum_sort;
                          _sort = 'sales_sum';
                          _sort_asc=_selnum_sort?'asc':'desc';
                          redoseach();
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text("销量"),
                          Icon(_selnum_sort
                              ? Icons.arrow_drop_up
                              : Icons.unfold_more,color: Colors.black45,)
                        ],
                      )),
                  FlatButton(
                      textColor: Colors.black54,
                      onPressed: () {
                        setState(() {
                          _selnum_sort = !_selnum_sort;
                          _sort = 'sales_sum';
                          _sort_asc=_selnum_sort?'asc':'desc';
                          redoseach();
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text("筛选"),
                          Icon(Icons.dashboard,color: Colors.black45,)
                        ],
                      )),
                ],
              ),
              listData != null
                  ? IndexHotListFloor(listData)
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Text("什么都没有发现"),
                    )
            ],
          ),
        ),
      );
    }

    if (widget.catname.isNotEmpty)
      return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              titleSpacing: 0,
              title: widget.keyword != ''
                  ? SearchListTopBarTitleWidget(keyworld: widget.keyword)
                  : Text(widget.catname)),
          body: ListView(
            controller: scrollController,
            children: <Widget>[
              listData != null
                  ? IndexHotListFloor(listData)
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Text("什么都没有发现"),
                    )
            ],
          ));
    else {
      return Material(
        child: SafeArea(
            child: Container(
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              Visibility(visible: widget.showlist, child: catlist()),
              listData.isNotEmpty
                  ? IndexHotListFloor(listData)
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text("什么都没有发现"),
                      ),
                    )
            ],
          ),
        )),
      );
    }
  }

  bool _showmore = false;
  bool _isadd0 = true;
  int _rcount = 5;
  Widget catlist() {
    if (_showmore) itm.removeAt(2 * _rcount - 1);
    int clen = itm.length;
    return Container(
      color: Color(0xFFFFFFFF),
      height: !_showmore
          ? (clen < 10 ? (80 * (clen / _rcount).ceilToDouble()) : 160)
          : (80 * (clen / _rcount).ceilToDouble()),
      child: Column(
        children: <Widget>[
          Expanded(
              child: GridView.count(
                semanticChildCount: 10,
            padding: EdgeInsets.all(5),
            crossAxisSpacing: 2,
            crossAxisCount: _rcount,
            mainAxisSpacing: 5,
            children: itm.map((it) {
              return Container(
                  child: InkWell(
                      onTap: () {
                        print(it);
                        if (it['ucid'] == 0)
                          setState(() {
                            _showmore = true;
                          });
                        else
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return CategryGoodsPage(
                                catid: it['ucid'], catname: it['name']);
                          }));
                      },
                      child: Container(
                        height: 68,
                          margin: EdgeInsets.all(2),
                          child: it['ucid'] == 0 && !_isadd0
                              ? Center(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.blur_circular,
                                          size: 20,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      Text(
                                        "更多",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 40,
                                        width: 40,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'images/logo-no.png',
                                              ),
                                              Text(
                                                "图片无法显示",
                                                style: TextStyle(
                                                    color: Colors.black26),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Loading(),
                                      imageUrl: it['icon'],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    Text(
                                      it['name'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ))
//
                      ));
            }).toList(),
          )),
        ],
      ),
    );
  }

  int page = 1;
  List<Map<String, dynamic>> listData = List();
  String keyword;
  int catid;

  void redoseach() async {
    page = 1;
    listData = List();
    await getSearchList();
  }

  Future getSearchList() async {
    Map<String, String> params = {};
//    listData=
  }

  @override
  void initState() {
    setState(() {
      keyword = widget.keyword;
      catid = widget.catid;
      if (widget.catitem != null) {
        _isadd0 = true;
        int i = 0;
        (widget.catitem['lists'] as List).forEach((iit) {
          if (i == (2 * _rcount - 1) && _isadd0) {
            if (!widget.is_end) itm.add({'ucid': 0, 'name': "更多", 'icon': ""});
            _isadd0 = false;
          }

          itm.add(iit);
          i += 1;
        });
      }
    });

    super.initState();
    getSearchList();
//    if(widget.catitem!=null)
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        getSearchList();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController = null;
    listData = null;
    page = null;
    super.dispose();
  }
}
