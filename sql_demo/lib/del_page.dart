import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sql_user.dart';
import 'sql_connect.dart';

class DelPage extends StatefulWidget {
  @override
  _DelPageState createState() => _DelPageState();
}

class _DelPageState extends State<DelPage> {
  List<User> data = [];

  Future<List<User>> query() async {
    List<User> data = [];
    final sql = SqlConnect();
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
        appBar: AppBar(
          title: Text('刪除頁面'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: query(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final result = snapshot.data;
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
        ));
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
              final birth=DateFormat('yyyy/MM/dd').format(widget.data[index].birth);
              return Card(
                  child: ListTile(
                  title: Text('id : $id\nname : $name\naddress : $addr\nbirthday : $birth'),
                  onTap: (){
                    showDialog(
                          context: context, 
                          builder: (context)=>AlertDialog(
                            content: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded),
                                Text('確定要刪除id=$id的資料嗎')
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: Text('確定'),
                                onPressed: ()async{
                                  final sql = SqlConnect();
                                  await sql.sqlInitial();
                                  var querystr = 'DELETE FROM x WHERE id = ?';
                                  await sql.conn.query(querystr,[id]);
                                  sql.conn.close();
                                  Navigator.of(context,rootNavigator: true).pop();
                                  setState(() {
                                    widget.data.remove(widget.data[index]);
                                  });
                                }
                              ),
                              ElevatedButton(
                                child: Text('取消'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                }
                              )
                            ]
                          )
                        ); 
                  },
                ),
              );
            },
          );
  }
}
