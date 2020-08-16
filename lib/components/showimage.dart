import 'package:flutter/material.dart';
import 'loading_gif.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

class ShowNetImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final bool tapnull;
  ShowNetImage(this.image,{this.height=0.0,this.width=0.0,this.tapnull=true});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: !tapnull ?
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (BuildContext context) {
                return ShowImage(this.image);
              }));
            },
            child: buildCacheImge(context))
    :
        buildCacheImge(context)
    );
  }

  Widget buildCacheImge( context){
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Container(
        width: MediaQuery.of(context).size.width / 5,
        child: Center(
          child: Container(
            height: this.height==0.0 ? 85:this.height,
            width: this.width==0.0 ? 85:this.width,
            child: Image.asset(
              'images/logo-no.png',
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Loading(),
      imageUrl: this.image,
//              height: this.height==0.0 ? MediaQuery.of(context).size.width / 5:this.width,
      width: this.width==0.0 ? MediaQuery.of(context).size.width / 5:this.width,
      fit: BoxFit.fill,
    );
  }
}

class ShowImage extends StatelessWidget {
  final String image;
  ShowImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Material(
        //创建透明层
//        type: MaterialType.transparency, //透明类型
        child: Container(
            child: Stack(
      children: <Widget>[
        Container(
          child: DragScaleContainer(
              doubleTapStillScale: true,
              child: CachedNetworkImage(
            errorWidget: (context, url, error) => Container(
              width: MediaQuery.of(context).size.width / 10,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/logo-no.png',
                    ),
                    Text("无法显示")
                  ],
                ),
              ),
            ),
            placeholder: (context, url) => Loading(),
            imageUrl: this.image,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
//            fit: BoxFit.fill,
          ),
          )
        ),
        Positioned(
            top: 15,
            left: 8,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Color(0x2f00000),
              child: Row(
                children: <Widget>[
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,color: Colors.white,),
                        onPressed: () => Navigator.of(context).pop(),
                      )),
                  SizedBox(
                    width: 100,
                  )
                ],
              ),
            ))
      ],
    )));
  }
}
