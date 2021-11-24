// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webViewController;
  String uri = '';

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/html/index.html');
    String theURI = Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    setState(() {
      uri = theURI;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHtmlFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JS交互',),
        actions: [
          OutlinedButton(
              onPressed: () {
                _webViewController!.runJavascript('callFlutter()');
                // _webViewController!.evaluateJavascript('callJS(\'flutter与js交互\');');
              },
              child: const Text('授权', style: TextStyle(color: Colors.black)))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            // initialUrl: 'http://47.117.135.240:8088/files/web-mobile/index.html',
            initialUrl: '',
            javascriptChannels: [_toastJsChannel(context)].toSet(),
            onWebViewCreated: (WebViewController controller) {
              print("webview page: webview created...");
              _webViewController = controller;
              _webViewController!.loadUrl(uri);
            },
            onPageFinished: (url) {
              // String script = "window.userid=1";
              // _webViewController!.evaluateJavascript(script).then((result){
              //   print("flutter传值给js == " + result);
              // });
              _webViewController!.evaluateJavascript("flutterCallJsMethod('message from Flutter!')");
              print("webview page: load finished...url=$url");
            },
          )),
          // Container(width: double.infinity,height: 40,color: Colors.green,),
        ],
      ),
    );
  }

  // 创建 JavascriptChannel
  JavascriptChannel _toastJsChannel(BuildContext context) => JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        print("get message from JS, message is: ${message.message}");
      });
}
