import 'package:flutter/material.dart';
import 'package:flutter_7segencoder/CommonAnode.dart';
import 'package:flutter_7segencoder/CommonCathode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '7seg Encoder'),
      debugShowCheckedModeBanner: false,  // 去除右上方Debug標誌
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(
              tabs: [
                Tab(text: "Common Cathode"),
                Tab(text: 'Common Anode')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              new CommonCathode(),
              new CommonAnode()
            ],
          ),
        )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
