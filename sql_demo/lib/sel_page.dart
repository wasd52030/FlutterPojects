import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sql_user.dart';
import 'sql_connect.dart';

class SelPage extends StatefulWidget {
  
  @override
  _SelPageState createState() => _SelPageState();
}

class _SelPageState extends State<SelPage> {
  List<User> data=[];

  Future<List<User>> query() async {
    List<User> data=[];
    final sql= SqlConnect();
    await sql.sqlInitial();
    var querystr = 'SELECT * FROM x';
    var result = await sql.conn.query(querystr);
    result.forEach((element) {
      var m = User(
        element['id'],
        element['name'],
        element['addr'],
        element['birth'],
      );
      data.add(m);
    });
    sql.conn.close();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('查詢頁面')),
      body:Center(
    child: FutureBuilder<List<User>>(
          future: query(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final result=snapshot.data;
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Display(result);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      )
    );
  }
}

class Display extends StatefulWidget {

  Display(this.data);
  final List<User> data;

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return widget.data==null 
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context,index){
              final id=widget.data[index].id;
              final name=widget.data[index].name;
              final addr=widget.data[index].addr;
              final birth=DateFormat('yyyy/MM/dd').format(widget.data[index].birth.toLocal());
              return Card(
                  child: ListTile(
                  title: Text('id : $id\nname : $name\naddress : $addr\nbirthday : $birth'),
                  onTap: (){
                    showDialog(
                      context: context, 
                      builder: (context)=>AlertDialog(
                        content: Text('id=$id is Taped!'),
                        actions: [
                          ElevatedButton(
                            child: Text('ok'),
                            onPressed: ()=>Navigator.of(context).pop(),
                          )
                        ],
                      )
                    );
                  },
                ),
              );
            },
          );
  }
}