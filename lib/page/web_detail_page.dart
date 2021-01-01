import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logger/logger.dart';

class WebDetailPage extends StatefulWidget {
  final String title;
  final String url;

  const WebDetailPage({Key key, this.title, this.url}) : super(key: key);

  @override
  _WebDetailPageState createState() => _WebDetailPageState();
}

class _WebDetailPageState extends State<WebDetailPage> {
  var logger = Logger();
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  double _progress = 0;
  bool isShowProgressBar = false;
  StreamSubscription<WebViewHttpError> _onHttpError;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
      routes: {
        "/": (_) => WebviewScaffold(
              url: widget.url,
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: Text(
                  widget.title,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                ),
              ),
              withLocalStorage: true,
              withZoom: false,
              withJavascript: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text("loading..."),
                ),
              ),
            )
      },
    );
  }

  @override
  void initState() {
    super.initState();
    logger.d("title=${widget.title}  url=${widget.url}");
    flutterWebViewPlugin.onProgressChanged.listen((progress) {
      logger.d("progress = $progress");
      if (progress < 1) {
        setState(() {
          _progress = progress;
          isShowProgressBar = true;
        });
      } else if (progress == 1) {
        setState(() {
          isShowProgressBar = false;
          _progress = progress;
        });
      }
    });
    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      logger.d("state = ${state.type}");
    });
    _onHttpError = flutterWebViewPlugin.onHttpError.listen((error) {
      logger.e("error= $error");
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    _onHttpError.cancel();
    super.dispose();
  }
}
