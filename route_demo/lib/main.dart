import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homepage(),
      routes: <String,WidgetBuilder>{
        '/s2':(context)=>second_widget()
      }
    );
  }
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text('aaaa'),
            ElevatedButton(
              child: Text('切換頁面'),
                onPressed: (){
                  Navigator.of(context).pushNamed('/s2');
                }
            ),
            ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context, 
                    builder: (_){
                      return AlertDialog(
                        title: Text('title'),
                        content: Text('a\nb\nc\n'),
                        actions: [
                          ElevatedButton(
                            child: Text('ok'),
                            onPressed: (){
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          )
                        ],
                      );
                    }
                  );
                },
                child: Text('Dialog demo')
            )
          ],
        )
      ),
    );
  }
}

class second_widget extends StatefulWidget {
  const second_widget({
    Key key,
  }) : super(key: key);

  @override
  _second_widgetState createState() => _second_widgetState();
}

class _second_widgetState extends State<second_widget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text('bbbb'),
            ElevatedButton(
                child: Text('返回主頁面'),
                onPressed: (){
                  Navigator.pop(context);
                } 
            )
          ],
        ),
      )
    );
  }
}