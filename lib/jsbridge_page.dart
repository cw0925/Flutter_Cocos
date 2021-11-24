// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'jsbridge_util.dart';

class JsbridgePage extends StatefulWidget {
  @override
  _JsbridgePageState createState() => _JsbridgePageState();
}

class _JsbridgePageState extends State<JsbridgePage> {
  WebViewController? _webViewController;
  String uri = '';

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/web-mobile/index.html');
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
                JsBridgeUtil.getInstance()!.callJsFunc('testCallFromFlutter',params: {'userid':2},callback: (value){
                  print('Flutter 调用js' +  value.toString());
                });
              },
              child: const Text('授权', style: TextStyle(color: Colors.black)))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: WebView(
                initialUrl: 'http://47.117.135.240:8088/files/web-mobile/index.html',
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: [_toastJsChannel(context)].toSet(),
                debuggingEnabled: true,
                onWebViewCreated: (WebViewController controller) {
                  print("webview page: webview created...");
                  _webViewController = controller;
                },
                onPageFinished: (url) {
                  // String script = "window.userid=1";
                  // _webViewController!.evaluateJavascript(script).then((result){
                  //   print("flutter传值给js == " + result);
                  // });
                  // _webViewController!.evaluateJavascript("flutterCallJsMethod('message from Flutter!')");
                  print("webview page: load finished...url=$url");
                  JsBridgeUtil.getInstance()!.init(_webViewController!);
                },
              )),
          // Container(width: double.infinity,height: 40,color: Colors.green,),
        ],
      ),
    );
  }

  // 创建 JavascriptChannel
  JavascriptChannel _toastJsChannel(BuildContext context) => JavascriptChannel(
      name: 'FlutterBridge',
      onMessageReceived: (JavascriptMessage message) {
        String jsonString = message.message;
        JsBridgeUtil.getInstance()!.executeMethod(JsBridgeUtil.getInstance()!.parseJson(jsonString));
        print('接收返回的数据：'+ jsonString);
      });
}
