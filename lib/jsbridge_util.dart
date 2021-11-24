/// 调用js函数需要在webview加载完成后才可调用

import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class JsBridgeUtil{

  static JsBridgeUtil? _instance;

  static JsBridgeUtil? getInstance() {
    if (_instance == null) {
      _instance = JsBridgeUtil();
    }
    return _instance;
  }

  String bridge_key = "BRIDGE_CBKEY_";

  int _callbackId = 0;

  WebViewController? webController;

  /// flutter注册的用于js调用的方法
  Map<String, Function> registerFuncs = Map();
  /// flutter调用js方法后的回调函数表
  Map<String, Function> responseFuncs = Map();

  init(WebViewController controller){
    webController = controller;
  }

  Protocol parseJson(String jsonString) {
    Protocol jsBridgeModel = Protocol.fromMap(jsonDecode(jsonString));
    return jsBridgeModel;
  }

  /// 调用js的方法 method: 方法名 params: 参数 callback: 回调函数
  callJsFunc(String method, {var params, Function? callback}){
    if (method.isEmpty) return;
    params = (params==null) ? "" : params;

    var callbackID;
    if(callback != null){
      callbackID = bridge_key + (++_callbackId).toString();
      responseFuncs[callbackID] = callback;
    }

    if(webController != null){
      Protocol funcmodel = Protocol(method, params, callbackID);
      var func = jsonEncode(funcmodel);
      webController!.runJavascript("jsBridge.callFuncFromFlutter($func)");
      print('callJsFunc==$func');
    }
  }

  /// 注册方法(若返回数据给js需要以String或json类型返回)method:方法名 func:method对应的方法
  registerForJs(String method, Function func){
    registerFuncs[method] = func;
  }

  /// 处理javascript的调用函数
  executeMethod(Protocol jsonMessage) {
    if(jsonMessage.method.isNotEmpty){
      if(jsonMessage.method == "response"){
        /// js返回的数据
        if (jsonMessage.callbackID !=  null && responseFuncs[jsonMessage.callbackID] != null){
          Function? call = responseFuncs[jsonMessage.callbackID];
          call!(jsonMessage.params);
          // responseFuncs.remove(jsonMessage.callbackID);
        }
      }else{
        /// js调用的函数
        if (jsonMessage.method.isNotEmpty && registerFuncs[jsonMessage.method] != null){
          if(jsonMessage.callbackID != null){
            /// 需要返回数据
            String response = registerFuncs[jsonMessage.method]!(jsonMessage.params);
            if(webController != null){
              Protocol funcmodel = Protocol("response", response, jsonMessage.callbackID);
              var func = jsonEncode(funcmodel);
              webController!.evaluateJavascript("jsBridge.responseFromFlutter($func)");
            }
          }else{
            /// 不需要返回数据(dart函数写法要接收参数,参数可以不用)
            registerFuncs[jsonMessage.method]!(jsonMessage.params);
          }
          /// 不去除，便于多次执行
          // registerFuncs.remove(jsonMessage.method);
        }
      }
    }
  }


}

class Response{
  String responseID;
  Function func;
  Response(this.responseID, this.func);
}

class Protocol {
  /// 方法名
  String method;
  /// 参数 string map
  var params;
  /// 回调id
  var callbackID;

  Protocol(this.method, this.params, this.callbackID);

  /// jsonEncode方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map toJson() {
    Map map = new Map();
    map['method'] = this.method;
    map['params'] = this.params;
    map['callbackID'] = this.callbackID;
    return map;
  }
  /// jsonDecode(jsonStr)方法返回的是Map<String, dynamic>类型，需要这里将map转换成实体类
  static Protocol fromMap(Map<String, dynamic> map) {
    Protocol jsonModel =  new Protocol(map['method'], map['params'], map['callbackID']);
    return jsonModel;
  }

  @override
  String toString() {
    return "{method: $method, data: $params, callbackID: $callbackID}";
  }
}

