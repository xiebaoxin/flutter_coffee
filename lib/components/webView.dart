import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/DialogUtils.dart';

class WebViewNew extends StatefulWidget {
  final String articleUrl;
  final String title;
  final bool withtoken;

  WebViewNew(this.title, this.articleUrl,{this.withtoken=false});

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<WebViewNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isloaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(widget.title),
        ),
        body: Container(
          
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Visibility(
                  visible: !_isloaded,
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: <Widget>[
                            DialogUtils.uircularProgress(),
                            SizedBox(
                              height: 10,
                            ),
                            Text('正在打开，请稍后.....'),
                          ],
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  child: WebView(
                initialUrl: widget.articleUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (String url) {
                  setState(() {
                    _isloaded = true;
                  });
                },
              ))
            ],
          ),
        ));
  }
}
