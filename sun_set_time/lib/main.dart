import 'package:flutter/material.dart';
import 'loading_view.dart';
import 'result_view.dart';
import 'error_page.dart';
import 'api_repsone.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sun set time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<String> getTimeString() async{
    var data=await ApiRepsone().getData();
    var timestring=data['results']['sunset'];
    var x=DateTime.parse(timestring).toLocal();
    return "${x.hour}:${x.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: getTimeString(),
          builder: (context,snapshot){
            if(snapshot.hasData)
            {
              return ResultView(snapshot.data);
            }
            else if(snapshot.hasError)
            {
              return ErrorView(
                onRefshButtonClick:()=>setState((){})
              );
            }
            else
            {
              return LoadgingView();
            }
          },
        ),
      ),
    );
  }
}


