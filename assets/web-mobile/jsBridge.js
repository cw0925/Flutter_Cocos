/**
 *  interaction protocol defined json {method: xxx, params: xxx, callbackID: xxx}
 *  response protocol defined json {method: response, params: xxx, callbackID: xxx}
 */
 
 (function(){
    if (window.jsBridge){
    	return;
    }
 
    // response 回调前缀
    var BRIDGE_CALL_KEY = "BRIDGE_CBKEY_";
 
    var _callbackId = 0;
 
    // funcs of javascript registered  for native
    var registerFuncMap = {};
    // get response from flutter after call flutter
    var responseCallMap = {};
 
    // register js func for Flutter call
    function registerFuncForFlutter(funcName, func){
        registerFuncMap[funcName] = func;
    }
 
    // js call Flutter func
    function callFlutterFunc(funcName, params, callback){
        var callbackId = null;
        if (callback){
            callbackId = BRIDGE_CALL_KEY + (++_callbackId);
            responseCallMap[callbackId] = callback;
        }
        if (funcName){
            try{
                // flutter webview's userAgent need add "FlutterBridge"
                // BridgeRequest is an object defined by flutter for javascript call flutter func
                var agent = navigator.userAgent;
                if(agent.includes("FlutterBridge")){
                    params = (params==null)?"":params;
                    FlutterBridge.postMessage(JSON.stringify({method: funcName, params: params, callbackID: callbackId}));
                }
            }catch(exception){
                if (typeof console != 'undefined'){
                    console.log(`jsBridge: callFlutterFunc ${funcName} failed >>` + exception);
                    alert(`jsBridge: callFlutterFunc ${funcName} failed >>` + exception);
                }
            }
        }
    }
 
    // flutter call js func {"method":"testCallFromFlutter","params":"2","callbackID":"BRIDGE_CBKEY_10"}
    function callFuncFromFlutter(msgJson){
        var responseCall = null;
        var jsFunc = null;
        if (msgJson.method) {
            jsFunc = registerFuncMap[msgJson.method];
        }
        if (msgJson.callbackID){
            responseCall = function(responseData){
                sendResponseToFlutter(msgJson.callbackID, responseData);
            }
        }
        console.log(`callbackID = ${msgJson.callbackID}`);
        console.log(`responseCall = ` + responseCall);
        alert(`callbackID = ${msgJson.callbackID}`+`responseCall = ` + responseCall);
        if (jsFunc){
            try{
                jsFunc(msgJson.params, responseCall);
            }catch(exception){
                if (typeof console != 'undefined'){
                    console.log(`jsBridge: callFuncFromFlutter ${msgJson.method} failed >>` + exception);
                    alert(`jsBridge: callFuncFromFlutter ${msgJson.method} failed >>` + exception)
                }
            }
        }
    }
 
    // flutter response to js
    function responseFromFlutter(msgJson){
        // no need json parse
        if (msgJson.callbackID && responseCallMap[msgJson.callbackID]){
            try{
                var responseData = isJSON(msgJson.params)?JSON.parse(msgJson.params):msgJson.params;
                responseCallMap[msgJson.callbackID](responseData);
            }catch(exception){
                if (typeof console != 'undefined'){
                    console.log(`jsBridge: responseFromFlutter failed >>` + exception);
                    alert(`jsBridge: responseFromFlutter failed >>` + exception)
                }
            }
        }
    }
 
    // call flutter func named callResponse to response data
    function sendResponseToFlutter(callbackID, response){
        response = (response==null)?"":response;
        var responseData = isJSON(response)?JSON.parse(response):response;
        var agent = navigator.userAgent;
        if(agent.includes("FlutterBridge")){
            FlutterBridge.postMessage(JSON.stringify({method: "response", params: responseData, callbackID: callbackID}));
        }
 
    }
 
 
    function isJSON(str) {
        if (typeof str == 'string') {
            try {
                var obj=JSON.parse(str);
                if(typeof obj == 'object' && obj ){
                    return true;
                }else{
                    return false;
                }
            } catch(e) {
                return false;
            }
        }
        return false;
    }
 
    var jsBridge = window.jsBridge = {
        callFuncFromFlutter: callFuncFromFlutter,
        responseFromFlutter: responseFromFlutter,
        registerFuncForFlutter: registerFuncForFlutter,
        callFlutterFunc: callFlutterFunc
    };
 
    var doc = document;
    var readyEvent = doc.createEvent('Events');
    // readyEvent=new Event("jsBridgeReady");
    readyEvent.initEvent('jsBridgeReady');
    readyEvent.bridge = jsBridge;
    doc.dispatchEvent(readyEvent);
 
})();