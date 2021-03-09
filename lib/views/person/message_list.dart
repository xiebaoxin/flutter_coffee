import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../components/details_html.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
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
//                      color: Colors.transparent,
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
//                                padding: EdgeInsets.symmetric(vertical: 12),
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

class NewsListPageState11 extends State<MessageList> {
  ScrollController _scrollController = ScrollController(); //listview的控制
  int _page = 0;

  List<dynamic> _payLogList = List();
  _loadData() async {
      _payLogList=await DataUtils.getMyMessageList(context,_page,pagesize: 20);
      setState(() { });
  }


  _getBody() {
    int length = _payLogList.length;
    return _payLogList.isNotEmpty? ListView.builder(
      itemCount: length,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index == length) {
          _loadData();
          return new Center(
            child: new Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (index > length) {
          return null;
        }else{
          return _getItem(_payLogList[index]);
        }
      },
    ):
    Center(
      child: Text("什么都没有"),
    );

  }
int _indexit=0;
  Widget _getItem(dynamic item){
    bool stat=item['status']==0?false:true;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 2),
      child:
      GestureDetector(
        onTap: ()async{
          if(!stat){
            await DataUtils.setMessageRead(context, item['id']);
          }
          MessageDetail.show(context,item);
          setState(() {
            _indexit=item['id'];
          });
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
//              DetailsHtml(item["context"])
              /* Visibility(
                visible: _indexit==item['id'],
                     child: DetailsHtml(item["context"])),*/

            ],
          ),
        ) ,
      )
      ,
    );
  }
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _loadData();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的消息'),
      ),
      body: Center(
        child: _getBody(),
      ),
    );
  }
}
class NewsListPageState extends State<MessageList> {
  static const int PAGE_SIZE = 20;
  bool _headersm = true;//true为白底false为绿底
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text("我的消息"),
                ),
//                backgroundColor: KColorConstant.backgroundColor,
                body: _getBody(context));
  }

  final _pageLoadController = PagewiseLoadController(
      pageSize: PAGE_SIZE,
      pageFuture: (pageIndex) =>DataUtils.getMyMessageList(G.navigatorKey.currentContext,pageIndex,pagesize: PAGE_SIZE)//getPosts(context,this.type,pageIndex, PAGE_SIZE)
  );

   Widget _getBody(context) {
     return RefreshIndicator(
       onRefresh: () async {
         _pageLoadController.reset();
         await Future.value({});
       },
       child: PagewiseListView(
         itemBuilder: _itemBuilder,
         noItemsFoundBuilder: (context) {
           return Text('没有数据哦');
         },
         loadingBuilder: (context) {
           return Loading();
         },
         pageLoadController: _pageLoadController,
       ),
     );
   }

  Widget _itemBuilder(context, dynamic item, _) {
    bool stat=item['status']==0?false:true;
    return Container(
        padding: EdgeInsets.fromLTRB(8, 5, 8, 2),
      child:
      GestureDetector(
        onTap: ()async{
          if(!stat){
            await DataUtils.setMessageRead(context, item['id']);
            _pageLoadController.reset();
            await Future.value({});
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
//              DetailsHtml(item["context"])
             /* Visibility(
                visible: _indexit==item['id'],
                     child: DetailsHtml(item["context"])),*/

            ],
          ),
        ) ,
      )
      ,
    );
  }

   @override
   void initState() {
     super.initState();
   }

   @override
   void dispose() {
     super.dispose();
   }


}

