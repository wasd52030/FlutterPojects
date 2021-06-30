import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter BMI Calc Demo'),
      debugShowCheckedModeBanner: false,  // 去除右上方Debug標誌
    );
  }
}

class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  TextEditingController _Textbox1=TextEditingController();
  TextEditingController _Textbox2=TextEditingController();
  double _x=0;

  void _bmi()
  {
      double h=double.parse(_Textbox1.text);
      double w=double.parse(_Textbox2.text);
      setState(() {
        h/=100;
        _x=w/(h*h);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("身高: ",style: TextStyle(fontSize: 25)),
              Expanded(child: TextField(keyboardType: TextInputType.number,controller: _Textbox1))
            ],
          ),
          Row(
            children: [
              Text("體重: ",style: TextStyle(fontSize: 25)),
              Expanded(child: TextField(keyboardType: TextInputType.number,controller: _Textbox2))
            ],
          ),
          ElevatedButton(onPressed:_bmi,child: Text("Calc")
          ),
          Text("BMI = $_x",style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}
