window.__require=function e(t,r,n){function o(c,u){if(!r[c]){if(!t[c]){var l=c.split("/");if(l=l[l.length-1],!t[l]){var a="function"==typeof __require&&__require;if(!u&&a)return a(l,!0);if(i)return i(l,!0);throw new Error("Cannot find module '"+c+"'")}c=l}var s=r[c]={exports:{}};t[c][0].call(s.exports,function(e){return o(t[c][1][e]||e)},s,s.exports,e,t,r,n)}return r[c].exports}for(var i="function"==typeof __require&&__require,c=0;c<n.length;c++)o(n[c]);return o}({Helloworld:[function(e,t,r){"use strict";cc._RF.push(t,"e1b90/rohdEk4SdmmEZANaD","Helloworld");var n,o=this&&this.__extends||(n=function(e,t){return(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var r in t)Object.prototype.hasOwnProperty.call(t,r)&&(e[r]=t[r])})(e,t)},function(e,t){function r(){this.constructor=e}n(e,t),e.prototype=null===t?Object.create(t):(r.prototype=t.prototype,new r)}),i=this&&this.__decorate||function(e,t,r,n){var o,i=arguments.length,c=i<3?t:null===n?n=Object.getOwnPropertyDescriptor(t,r):n;if("object"==typeof Reflect&&"function"==typeof Reflect.decorate)c=Reflect.decorate(e,t,r,n);else for(var u=e.length-1;u>=0;u--)(o=e[u])&&(c=(i<3?o(c):i>3?o(t,r,c):o(t,r))||c);return i>3&&c&&Object.defineProperty(t,r,c),c};Object.defineProperty(r,"__esModule",{value:!0});var c=cc._decorator,u=c.ccclass,l=c.property,a=function(e){function t(){var t=null!==e&&e.apply(this,arguments)||this;return t.label=null,t.text="hello",t}return o(t,e),t.prototype.start=function(){this.label.string=this.text},i([l(cc.Label)],t.prototype,"label",void 0),i([l],t.prototype,"text",void 0),i([u],t)}(cc.Component);r.default=a,cc._RF.pop()},{}],JSBridgeManager:[function(e,t,r){"use strict";cc._RF.push(t,"91602sovqlGcLKvYLULIlp+","JSBridgeManager"),Object.defineProperty(r,"__esModule",{value:!0}),r.JSBridgeManager=void 0;var n=function(){function e(){}return e.getInstance=function(){return null==e._instance&&(e._instance=new e),this._instance},e.prototype.registerFunc=function(e,t){window.jsBridge?window.jsBridge.registerFuncForFlutter(e,t):document.addEventListener("jsBridgeReady",function(){window.jsWebBridge.registerFuncForFlutter(e,t)},!1)},e.prototype.callFlutterFunc=function(e,t,r){window.jsBridge&&window.jsBridge.callFlutterFunc(e,t,r)},e}();r.JSBridgeManager=n,cc._RF.pop()},{}]},{},["Helloworld","JSBridgeManager"]);