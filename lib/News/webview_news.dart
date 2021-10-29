import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_app/log%20screens/custom_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViews extends StatefulWidget {
  final String url;
  const NewsWebViews({Key? key, required this.url}) : super(key: key);

  @override
  _NewsWebViewsState createState() => _NewsWebViewsState();
}

class _NewsWebViewsState extends State<NewsWebViews> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              initialUrl: widget.url,
              onWebViewCreated: ((WebViewController webviewcontroller) {
                _completer.complete(webviewcontroller);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
