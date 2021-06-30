import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sql_demo/sql_connect.dart';
import 'package:sql_demo/sql_user.dart';

class AddPgae extends StatefulWidget {
  @override
  _AddPgaeState createState() => _AddPgaeState();
}

class _AddPgaeState extends State<AddPgae> {
  
  final id = TextEditingController();
  final name = TextEditingController();
  final addr = TextEditingController();
  final birth = TextEditingController();
  var sqlerrflag=false;

  Future insert(User m) async {
    final sql= SqlConnect();
    await sql.sqlInitial();
    var querystr = 'INSERT INTO x (id, name,addr,birth) VALUES (?, ?, ?, ?)';
    try {
      await sql.conn.query(querystr,[m.id,m.name,m.addr,m.birth.toUtc()]);
      sqlerrflag=true;
    } catch (e) {
      sqlerrflag=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增頁面'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("id: ", style: TextStyle(fontSize: 25)),
              Expanded(child: 
                TextField(
                keyboardType: TextInputType.number, 
                controller: id,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                )
              )
            ],
          ),
          Row(
            children: [
              Text("name: ", style: TextStyle(fontSize: 25)),
              Expanded(child: TextField(controller: name))
            ],
          ),
          Row(
            children: [
              Text("addr: ", style: TextStyle(fontSize: 25)),
              Expanded(child: (TextField(controller: addr)))
            ],
          ),
          Row(
            children: [
              Text("birth: ", style: TextStyle(fontSize: 25)),
              Expanded(
                  child: DateTimeField(
                  controller: birth,
                  format: DateFormat("y-mM-dd"),
                  onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1),
                        initialDate: currentValue ?? DateTime.now(), // currentValue==null時，設為DateTime.now()
                        lastDate: DateTime(9999)
                      );
                  },
                )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                child: Text('新增'),
                onPressed: ()async{
                  User data=User(
                    int.parse(id.text), 
                    name.text, addr.text, 
                    DateTime.parse(birth.text)
                  );
                  await insert(data);
                  if(sqlerrflag==false){
                    showDialog(
                      context: context, 
                      builder: (context)=>AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded),
                          ],
                        ),
                        content: Text(
                          '新增失敗'
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text('ok'),
                            onPressed: ()=>Navigator.of(context,rootNavigator: true).pop()
                          )
                        ]
                      )
                    );
                  }else{
                    showDialog(
                      context: context, 
                      builder: (context)=>AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline),
                          ],
                        ),
                        content: Text(
                          '新增成功'
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text('ok'),
                            onPressed: ()=>Navigator.of(context,rootNavigator: true).pop()
                          )
                        ]
                      )
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: Text('返回'),
                  onPressed: ()=>Navigator.of(context,rootNavigator: true).pop(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
