// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class CocosPage extends StatefulWidget {
  @override
  _CocosPageState createState() => _CocosPageState();
}

class _CocosPageState extends State<CocosPage> {

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocos页面'),
      ),
      body: Column(
        children: [
          Expanded(child: InAppWebView(
            ///storage/emulated/0/web-mobile/index.html
            // initialUrlRequest: URLRequest(url: Uri.parse("http://www.yuetengsoft.com/files/knife/index.html")),
            initialFile: 'assets/web-mobile/index.html',
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                supportZoom: false,
                useOnLoadResource: true,
                javaScriptEnabled: true,
                cacheEnabled: true,
                clearCache: true,
                mediaPlaybackRequiresUserGesture:  true,
                disableContextMenu: true,
                useShouldOverrideUrlLoading: true,
              ),
              android: AndroidInAppWebViewOptions(
                domStorageEnabled: true,
                builtInZoomControls: false,
                geolocationEnabled: true,
                allowFileAccess: true,
                allowContentAccess: true,
                displayZoomControls: false,
                useWideViewPort: true,
                supportMultipleWindows: true,
                networkAvailable: true,
                blockNetworkImage: false,
                mixedContentMode:
                AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                verticalScrollbarPosition:
                AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
                allowsAirPlayForMediaPlayback: true,
                allowsPictureInPictureMediaPlayback: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
              controller.addJavaScriptHandler(handlerName: "handlerName", callback: (List<dynamic> arguments){
                print("=============1" + arguments.toString());
                print("array: ${arguments[2].runtimeType.toString()}");
                print("dictionary: ${arguments[3].runtimeType.toString()}");
              });
            },
            onLoadStart: (controller, url){
              print('onLoadStart');
            },
            onLoadStop: (controller, url){
              print('onLoadStop');
            },
            onLoadError: (controller, url, index, err){
              print('onLoadError' + err);
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {},
            onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
              print("=============2" + consoleMessage.message);
            },
          )),
          // Container(width: double.infinity,height: 40,color: Colors.green,),
        ],
      ),
    );
  }
}