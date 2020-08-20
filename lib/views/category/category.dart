import 'package:flutter/material.dart';
import 'package:flutter_coffee/views/category/list_view_item.dart';
import 'package:flutter_coffee/views/category/menue.dart';
import 'package:flutter_coffee/views/category/right_list_view.dart';
import 'list_view_item.dart';
import 'menue.dart';
import 'right_list_view.dart';
import 'search_bar.dart';
import 'sub_category.dart';
import '../../globleConfig.dart';

class Category extends StatefulWidget {
  final double rightListViewHeight;
  Category({Key key, this.rightListViewHeight}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CategoryState();
}

class CategoryState extends State<Category> {
  var _categoryData=[];
  int currentPage = 0;
  GlobalKey<RightListViewState> rightListviewKey =
  new GlobalKey<RightListViewState>();
  GlobalKey<CategoryMenueState> categoryMenueKey =
  new GlobalKey<CategoryMenueState>();
  List<SubCategoryListModel> listViewData = [];
  bool isAnimating = false;
  int itemCount = 0;
  double menueWidth;
  double itemHeight;
  double height;
  @override
  Widget build(BuildContext context) {

    double extralHeight = Klength.topBarHeight + //顶部标题栏高度
        Klength.bottomBarHeight + //底部tab栏高度
        10 + //状态栏高度ScreenUtil.statusBarHeight
        30; //IPhoneX底部状态栏bottomBarHeight


    return Scaffold(
        appBar: new AppBar(
          backgroundColor: KColorConstant.mainColor,
          title: new Text('搜索',style: TextStyle(color: Color(0xFFFFFFFF)),),
          centerTitle: true,
          leading: SizedBox(width: 5,),
        ),
        body:  Container(
        color: Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            SearchBar(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      color: Color(0xFFf7f7f7),
                      width:  75,
                      child: CategoryMenue(
                          key: categoryMenueKey,
                          items: _categoryData.map((i){
                            return i['name'] as String;
                          }).toList(),
                          itemHeight:40,
                          itemWidth: 75,
                          menueTaped: menueItemTap),
                    ),
                  ),
                  RightListView(
                      key: rightListviewKey,
                      height:MediaQuery.of(context).size.height-extralHeight ,//widget.rightListViewHeight,
                      dataItems: listViewData,
                      listViewChanged: listViewChanged)
                ],
              ),
            )
          ],
        )));
  }

  menueItemTap(int i) {
    rightListviewKey.currentState.jumpTopage(i);
  }


  listViewChanged(i) {
    this.categoryMenueKey.currentState.moveToTap(i);
  }
  @override
  void reassemble() {
  /*  listViewData = _categoryData.map((i){
      return SubCategoryListModel.fromJson(i);
    }).toList();*/
    super.reassemble();
  }
  @override
  void initState() {
    categoryData();
    super.initState();
  }

  Future categoryData() async {
    List<dynamic> CategoryItems =[];
   /* await DataUtils.getIndexCategory(context).then((response){
      var cateliest = response["items"];
//      print(cateliest);
      cateliest.forEach((ele) {
        if (ele.isNotEmpty) {
          CategoryItems.add(ele);
        }
      });
      setState(() {
        _categoryData=CategoryItems;
        listViewData = _categoryData.map((i){
          return SubCategoryListModel.fromJson(i);
        }).toList();
      });

    });
*/
    return CategoryItems;
  }
}
