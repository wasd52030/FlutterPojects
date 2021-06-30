import 'package:flutter/material.dart';
import 'add_page.dart';
import 'sel_page.dart';
import 'del_page.dart';
import 'edit_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sql Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String,WidgetBuilder>{
        Navigator.defaultRouteName:(context)=>MyHomePage(),
        '/sel':(context)=>SelPage(),
        '/add':(context)=>AddPgae(),
        '/del':(context)=>DelPage(),
        '/ed':(context)=>EditPgae()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('資料庫老四件=>增刪改查'),
      ),
      body: Center(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('新增'),
                onPressed: ()=>Navigator.pushNamed(context, '/add')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('刪除'),
                onPressed: ()=>Navigator.pushNamed(context, '/del'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('修改'),
                onPressed: ()=>Navigator.pushNamed(context, '/ed')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('查詢'),
                onPressed: ()=>Navigator.pushNamed(context, '/sel')
              ),
            )
          ],
        )
      ),
    );
  }
}
