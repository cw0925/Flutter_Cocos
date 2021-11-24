import 'package:flutter/material.dart';
import 'package:flutter_cocos/cocos_page.dart';
import 'jsbridge_page.dart';
import 'webview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewPage())); }, child: const Text('webview跳转H5')),
            OutlinedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> CocosPage())); }, child: const Text('InAppWebView跳转cocos')),
            OutlinedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> JsbridgePage())); }, child: const Text('jsbridge跳转cocos')),
          ],
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

