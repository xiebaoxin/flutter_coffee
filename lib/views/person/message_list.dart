import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../../components/details_html.dart';
import '../../components/in_text_dot.dart';
import '../../components/loading_gif.dart';
import '../../utils/dataUtils.dart';
import '../../globleConfig.dart';

class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsListPageState();
}


class MessageDetail{
  static show(context,dynamic item){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AnimatedPadding(
            padding: EdgeInsets.zero,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: MediaQuery.removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
              context: context,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 280.0),
                  child: Material(
                      elevation: 24.0,
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      type: MaterialType.card,
                      child:
                      Container(
                        width: 335,
                        height: 580,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Icon(Icons.clear),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                            Center(child: Text(item['title'],softWrap: true,
                              style:TextStyle(fontWeight: FontWeight.bold),)),
                            Expanded(
                              child: Container(
                                child: DetailsHtml(item['context']),
                              ),
                            ),

                          ],
                        ),
                      )
                  ),
                ),
              ),
            ),
          );
        }
    );

  }
}

class NewsListPageState extends State<MessageList> {
  static const int PAGE_SIZE = 20;
  List<dynamic> _items = [];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final newItems = await DataUtils.getMyMessageList(
          context, _page, pagesize: PAGE_SIZE);
      setState(() {
        if (newItems == null || newItems.isEmpty) {
          _hasMore = false;
        } else {
          _items.addAll(newItems);
          _page++;
        }
      });
    } catch (e) {
      // ignore
    }
    _isLoading = false;
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
    });
    await _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("我的消息"),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: _items.isEmpty && !_hasMore
              ? Center(child: Text('没有数据哦'))
              : _items.isEmpty
                  ? Center(child: Loading())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _items.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _items.length) {
                          return Center(child: Loading());
                        }
                        return _itemBuilder(context, _items[index], index);
                      },
                    ),
        ));
  }

  Widget _itemBuilder(context, dynamic item, _) {
    bool stat=item['status']==0?false:true;
    return Container(
        padding: EdgeInsets.fromLTRB(8, 5, 8, 2),
      child:
      GestureDetector(
        onTap: ()async{
          if(!stat){
            DataUtils.setMessageRead(context, item['id']);
            _refresh();
          }
          MessageDetail.show(context,item);

        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['createTime']),
                    Visibility(visible:!stat,child: InTextDot())
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left:8.0),child: Text(item["title"])),

            ],
          ),
        ) ,
      )
      ,
    );
  }
}
