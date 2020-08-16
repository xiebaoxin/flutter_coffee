import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/swipper_indicator_style.dart';
import '../components/loading_gif.dart';
import '../model/banner.dart';

class RectSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rects
  final double space;

  final Key key;

  const RectSwiperPaginationBuilder(
      {this.activeColor,
        this.color,
        this.key,
        this.size: const Size(10.0, 2.0),
        this.activeSize: const Size(10.0, 2.0),
        this.space: 3.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    List<Widget> list = [];

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? this.activeSize : this.size;
      list.add(Container(
        width: size.width,
        height: size.height,
        color: active ? activeColor : color,
        key: Key("pagination_$i"),
        margin: EdgeInsets.all(space),
      ));
    }

    return new Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: list,
    );
  }
}

class SwipperBanner extends StatelessWidget {
  final BannerList bannerlist;
  final bool potype;
  final double nheight;
  final int defindex;
  final double widthsc;
  SwipperBanner({this.bannerlist, this.nheight=0.0,this.defindex=0,this.widthsc=0.0,this.potype=false});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =nheight==0.0?115:nheight;
    return Container(
      width: width-this.widthsc,
      height: height,
      child: Swiper(
        itemBuilder: (BuildContext context, index) {
          return  CachedNetworkImage(
            errorWidget: (context, url, error) =>Container(
              height: height,
              width: width,
              child: Center(
                child: Image.asset(
                  'images/topbg_img.jpg',),
              ),
            ),
            placeholder: (context, url) =>  Loading(),
            imageUrl:  bannerlist.items[index].picUrl,
            height: height,
            width: width,
            fit: BoxFit.fill,
          );
          /* return Image.network(
            banners[index],
            width: width,
            height: height,
          );*/
        },
        itemCount: bannerlist.items.length,
        //viewportFraction: 0.9,
        /*   pagination:  SwiperPagination(
            alignment:potype?Alignment.bottomRight: Alignment.bottomCenter,
            builder: potype?FractionPaginationBuilder(
                color: Colors.grey,
                activeColor: Colors.redAccent,
                activeFontSize: 20
            ):DotSwiperPaginationBuilder(
//              RectSwiperPaginationBuilder
                color: Color(0xFF999999),
                activeColor: Colors.white,
//                size: Size(5.0, 2),
//                activeSize: Size(5, 5)
            )),
        */
        pagination:  SwiperPagination(
            alignment:potype?Alignment.bottomRight: Alignment.bottomCenter,
            builder:SwiperCustomPagination(builder:(BuildContext context,SwiperPluginConfig config){
              return PageIndicator(layout: PageIndicatorLayout.NIO,count: config.itemCount,controller: config.pageController,size: 10,);
            } ) ),

        scrollDirection: Axis.horizontal,
        autoplay: true,
        index: defindex,
        onTap: (index){
          print('点击了第$index个');
//          if(iamgeitem!=null)
//          Application().adpage(context, iamgeitem[index]);

        }  ,
      ),
    );
  }
}
