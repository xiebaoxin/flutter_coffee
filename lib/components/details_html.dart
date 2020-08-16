import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsHtml extends StatelessWidget {
  final String  content;
  DetailsHtml(this.content);

  @override
  Widget build(BuildContext context) {
    String goodsDetails = this.content;

//    goodsDetails=goodsDetails.replaceAll('src="/public/upload/', 'src="${GlobalConfig.server}/public/upload/');
    goodsDetails=goodsDetails.replaceAll("\\", '/');

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Html(data: goodsDetails));
  }
}
