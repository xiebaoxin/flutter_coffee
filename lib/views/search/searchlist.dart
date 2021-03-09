import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/userinfo.dart';
import '../../model/globle_model.dart';
import '../../components/loading_gif.dart';
import '../index.dart';
import '../../utils/HttpUtils.dart';
import '../indexHotList.dart';
import '../categrygoods_page.dart';

class SearchResultListPage extends StatefulWidget {
  final String keyword;
  final String catname;
  final int catid;
  final int brand_id;
  final Map<String, dynamic> catitem;
  final bool showlist;
  final bool is_end;
  final int is_recom;
  final int is_new;
  final int is_hot;

  SearchResultListPage(this.keyword,
      {this.catid = 0,
      this.catname = '',
      this.brand_id = 0,
      this.catitem,
      this.showlist = false,
      this.is_end = false,
      this.is_recom=-1,
      this.is_hot=0,
      this.is_new=0
      });

  @override
  State<StatefulWidget> createState() => SearchResultListState();
}

class SearchResultListState extends State<SearchResultListPage> {
  ScrollController scrollController = ScrollController(); //listview的控制器
  Userinfo _userinfo = Userinfo.fromJson({});
  bool _price_sort = false, _selnum_sort = false;

  String _dropdownValue1 = '新品';

  String _is_new = '0', _sort = 'sort', _sort_asc = 'desc';

  @override
  Widget build(BuildContext context) {
    if (widget.is_end) {
      return Material(
          child: SafeArea(
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
                          _sort_asc = _price_sort ? 'asc' : 'desc';
                          redoseach();
                        });
                      },
                      textColor: Colors.black54,
                      child: Row(
                        children: <Widget>[
                          Text("价格"),
                          Icon(
                            _price_sort
                                ? Icons.arrow_drop_up
                                : Icons.unfold_more,
                          )
                        ],
                      )),
                  FlatButton(
                      textColor: Colors.black54,
                      onPressed: () {
                        setState(() {
                          _selnum_sort = !_selnum_sort;
                          _sort = 'sales_sum';
                          _sort_asc = _selnum_sort ? 'asc' : 'desc';
                          redoseach();
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text("销量"),
                          Icon(
                            _selnum_sort
                                ? Icons.arrow_drop_up
                                : Icons.unfold_more,
                            color: Colors.black45,
                          )
                        ],
                      )),
                  FlatButton(
                      textColor: Colors.black54,
                      onPressed: () {
                        Navigator.of(context)
                            .push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return bottomShowWidget();
                                }))
                            .then((v) {
                          if (v)
                            setState(() {
                              _selnum_sort = !_selnum_sort;
                              _sort = 'sales_sum';
                              _sort_asc = _selnum_sort ? 'asc' : 'desc';

                              redoseach();
                            });
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Text("筛选"),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.dashboard,
                              color: Colors.black45,
                              size: 12,
                            ),
                          )
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
      ));
    }

    if (widget.keyword.isNotEmpty)
      return Material(
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    titleSpacing: 0,
                    title:
                        SearchListTopBarTitleWidget(keyworld: widget.keyword)),
                body: Container(
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
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
                ))),
      );

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
  int _rcount = 5;
  Widget catlist() {
    List itm = List();
    if (widget.catitem == null)
      return SizedBox(
        height: 2,
      );

    List items = widget.catitem['lists'] as List;
//    print(items);
    if (items.length > 10) {
      if (_showmore)
        itm = items;
      else {
        for (int i = 0; i < 9; i++) {
          itm.add(items[i]);
        }

        itm.add({'ucid': 0, 'name': "更多", 'icon': ""});
      }
    } else
      itm = items;

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
//                        print(it);
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
                          child: it['ucid'] == 0
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

  String _pricearea = "";
  String _priceindex = "全部";

  String _brandarea = "";
  String _brandindex = "全部";

  var _specindex = new Map<int, String>();
  String _specarea = "";

  var _attrindex = new Map<int, String>();
  String _attrarea = "";

  List<Map<String, dynamic>> _priceListData = List();
  List<Map<String, dynamic>> _brandListData = List();
  List<dynamic> _specListData = List();
  List<dynamic> _attrListData = List();

  Widget bottomShowWidget() {
    return StatefulBuilder(builder: (context, state) {
      var _scaffoldkey1 = GlobalKey<ScaffoldState>();

      return Scaffold(
        backgroundColor: Color(0x0a0000000),
        // 设置key处理SnackBar，这里一定要设置，否则弹窗不显示
        key: _scaffoldkey1,

        body: SafeArea(
//          bottom: false,
          top: false,
          child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(253, 253, 253, 1),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.circular(20)),
                  border: null,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 60, 8, 8),
                  child: Container(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 45,
                                child: ListTile(
                                    title: Text("筛选"),
                                    trailing: Icon(Icons.close),
                                    onTap: () {
                                      Navigator.of(context).pop(false);
                                    }),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView(
                          children: <Widget>[
                            Container(
                              height: 40,
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "价格区间",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                                visible: _priceListData.isNotEmpty,
                                child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _priceListData.map((iti) {
                                      return ChoiceChip(
                                        key: ValueKey<String>(iti['value']),
                                        label: Text(
                                          iti['value'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                        //未选定的时候背景
                                        selectedColor: Color(0xFF29ccbb),
                                        backgroundColor: Color(0xfFaaaaaa),
                                        selected: _priceindex == iti['value'],
                                        onSelected: (bool value) {
                                          state(() {
                                            _priceindex = iti['value'];
                                            _pricearea = '';
                                            String rte = iti['href'].toString();
                                            if (rte.isNotEmpty) {
                                              _pricearea = rte.substring(
                                                  rte.indexOf("/price"));
                                            }
                                          });
                                        },
                                      );
                                      //                      return Text(iti.item);
                                    }).toList())),
                            Container(
                              height: 40,
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "品牌",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                                visible: _brandListData.isNotEmpty,
                                child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _brandListData.map((iti) {
                                      return ChoiceChip(
                                        key: ValueKey<String>(iti['name']),
                                        label: Text(
                                          iti['name'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                        //未选定的时候背景
                                        selectedColor: Color(0xFF29ccbb),
                                        backgroundColor: Color(0xfFaaaaaa),
                                        selected: _brandindex == iti['name'],
                                        onSelected: (bool value) {
                                          state(() {
                                            _brandindex = iti['name'];
                                            _brandarea = '';
                                            String rte = iti['href'].toString();
                                            if (rte.isNotEmpty) {
                                              _brandarea = rte.substring(
                                                  rte.indexOf("/brand_id"));
                                            }
                                          });
                                        },
                                      );
                                      //                      return Text(iti.item);
                                    }).toList())),
                            setspeclist(state),
                            setattrlist(state)
                          ],
                        )),
                        Container(
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: const Text('取消'),
                                onPressed: () {
                                  setState(() {
                                    _pricearea = '';
                                    _brandarea = '';
                                    _attrarea = '';
                                    _specarea = '';
                                  });
                                  Navigator.of(context).pop(true);
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FlatButton(
                                child: const Text('确定'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );
    });
  }

  Widget setspeclist(state) {
    return Visibility(
        visible: _specListData.isNotEmpty,
        child: Column(
          children: _specListData.map((item) {
            Map<String, dynamic> newitem = item;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          newitem['name'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (newitem['item'] as List).map((iti) {
                      return Visibility(
                          visible: true,
                          child: ChoiceChip(
                            key:
                                ValueKey<String>("${iti['key']}_${iti['val']}"),
                            label: Text(
                              iti['item'],
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFFFFFFFF)),
                            ),
                            //未选定的时候背景
                            selectedColor: Color(0xFF29ccbb),
                            backgroundColor: Color(0xfFaaaaaa),
                            selected: _specindex[newitem['spec_id']] ==
                                "${iti['key']}_${iti['val']}",
                            onSelected: (bool value) {
                              state(() {
                                _specindex[newitem['spec_id']] =
                                    "${iti['key']}_${iti['val']}";

                                _specarea = '';
                                _specindex
                                    .forEach((k, v) => _specarea += "@${v}");
                                _specarea = _specarea.replaceFirst("@", "");
//                                print(_specarea);
                              });
                            },
                          ));
                      //                      return Text(iti.item);
                    }).toList())
              ],
            );
          }).toList(),
        ));
  }

  Widget setattrlist(state) {
    return Visibility(
        visible: _attrListData.isNotEmpty,
        child: Column(
          children: _attrListData.map((item) {
            Map<String, dynamic> newitem = item;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          newitem['attr_name'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (newitem['attr_value'] as List).map((iti) {
                      return Visibility(
                          visible: true,
                          child: ChoiceChip(
                            key:
                                ValueKey<String>("${iti['key']}_${iti['val']}"),
                            label: Text(
                              iti['attr_value'],
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFFFFFFFF)),
                            ),
                            //未选定的时候背景
                            selectedColor: Color(0xFF29ccbb),
                            backgroundColor: Color(0xfFaaaaaa),
                            selected: _attrindex[newitem['attr_id']] ==
                                "${iti['key']}_${iti['val']}",
                            onSelected: (bool value) {
                              state(() {
                                _attrindex[newitem['attr_id']] =
                                    "${iti['key']}_${iti['val']}";

                                _attrarea = '';
                                _attrindex
                                    .forEach((k, v) => _attrarea += "@${v}");
                                _attrarea = _attrarea.replaceFirst("@", "");
//                                print(_attrarea);
                              });
                            },
                          ));
                      //                      return Text(iti.item);
                    }).toList())
              ],
            );
          }).toList(),
        ));
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

    params = {
      "q": keyword,
      "brand_id": widget.brand_id.toString(),
      'id': catid.toString(),
      'sort': _sort,
      'sort_asc': _sort_asc,
      'spec': _specarea,
      'attr': _attrarea,
      'is_new': _is_new,
      'is_hot':widget.is_hot.toString(),
      'recmd':widget.is_recom.toString(),
      'user_id': _userinfo.id
    };

    String url =
        "Shop/goodsList/p/${page.toString()}${_pricearea}${_brandarea}";

    if (keyword != '' || widget.brand_id > 0)
      url = "Shop/search/p/${page.toString()}/";

    var response = await HttpUtils.dioappi(url, params, context: null);

    try {
      if (response['list'] != null) {
        response['list'].forEach((ele) {
          if (ele != null) {
            var tee = ele as Map;
            if (tee != null) listData.add(tee);
          }
        });
        setState(() {
          page += 1;
        });
      }
    } catch (v) {
      ;
    }
    if (_priceListData.isEmpty) {
      try {
        if (response['filter'] != null) {
          if (response['filter']['filter_price'] != null) {
            setState(() {
//            _priceListData = List();
              response['filter']['filter_price'].forEach((ele) {
                if (ele != null) {
                  var tee = ele as Map;
                  if (tee != null) _priceListData.add(tee);
                }
              });
              _priceListData.insert(0, {"value": "全部", "href": ""});
            });
          }
//          print(_priceListData);
        }
      } catch (v) {
        ;
      }
    }

    if (_brandListData.isEmpty) {
      try {
        if (response['filter'] != null) {
          if (response['filter']['filter_brand'] != null) {
            setState(() {
              response['filter']['filter_brand'].forEach((ele) {
                if (ele != null) {
                  var tee = ele as Map;
                  if (tee != null) _brandListData.add(tee);
                }
              });
              _brandListData.insert(0, {"name": "全部", "href": ""});
            });
          }
//          print(_brandListData);
        }
      } catch (v) {
        ;
      }
    }

    if (_specListData.isEmpty) {
      try {
        if (response['filter'] != null) {
          if (response['filter']['filter_spec'] != null) {
            var filter_spec = response['filter']['filter_spec'];
            setState(() {
              filter_spec.forEach((ky, ele) {
                _specListData.add(ele);
              });
            });
          }
        }
      } catch (v) {
        ;
      }
    }

    if (_attrListData.isEmpty) {
      try {
        if (response['filter'] != null) {
          if (response['filter']['filter_attr'] != null) {
            var filter_attr = response['filter']['filter_attr'];
            setState(() {
              filter_attr.forEach((ky, ele) {
                _attrListData.add(ele);
              });
            });
          }
        }
      } catch (v) {
        ;
      }
    }
  }

  void initusrinfo() {
    final model = globleModel().of(context);
    _userinfo = model.userinfo;
  }

  @override
  void initState() {
    initusrinfo();
    _is_new=widget.is_new.toString();
    setState(() {
      keyword = widget.keyword;
      catid = widget.catid;
    });

    super.initState();
    getSearchList();
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
