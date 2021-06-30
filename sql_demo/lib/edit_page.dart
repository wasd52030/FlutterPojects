import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sql_user.dart';
import 'sql_connect.dart';

class EditPgae extends StatefulWidget {
  @override
  _EditPgaeState createState() => _EditPgaeState();
}

class _EditPgaeState extends State<EditPgae> {
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
          title: Text('修改頁面'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: query(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final result = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done) 
              {
                if (snapshot.hasError) 
                return Text("Error: ${snapshot.error}"); 
                else 
                  return Display(result);
              } else 
                  return Center(child: CircularProgressIndicator());
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
    return widget.data == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              var id = widget.data[index].id;
              var name = widget.data[index].name;
              var addr = widget.data[index].addr;
              var birth = DateFormat('yyyy/MM/dd').format(widget.data[index].birth.toLocal());
              return Card(
                child: ListTile(
                  title: Text(
                      'id : $id\nname : $name\naddress : $addr\nbirthday : $birth'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                            child: EditDialog(widget.data,index),
                          )
                        );
                  },
                ),
              );
            },
          );
  }
}

class EditDialog extends StatefulWidget {
  EditDialog(this.data,this.index);
  final List<User> data;
  final int index;
  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {

  var txtName=TextEditingController();
  var txtAddr=TextEditingController();
  var txtBirth=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.width - 130,
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline),
                Text(
                  '現正修改id=${widget.data[widget.index].id}的資料',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            Divider(height: 10),
            Row(
              children: [
                Text("name: ", style: TextStyle(fontSize: 25)),
                Flexible(child: TextFormField(controller: txtName) )
              ],
            ),
            Row(
              children: [
                Text("addr: ", style: TextStyle(fontSize: 25)),
                Flexible(child: TextFormField(controller: txtAddr))
              ],
            ),
            Row(
              children: [
                Text("birth: ", style: TextStyle(fontSize: 25)),
                Flexible(
                    child: DateTimeField(
                      controller: txtBirth,
                      format: DateFormat("y-mM-dd"),
                      onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1),
                        initialDate: currentValue ?? DateTime.now(),  // currentValue==null時，設為DateTime.now()
                        lastDate: DateTime(9999)
                      );
                    },
                  )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      ElevatedButton(
                        child: Text('確定'), 
                        onPressed: () async {
                          var edit = User(
                            widget.data[widget.index].id,
                            txtName.text,
                            txtAddr.text, 
                            DateTime.parse(txtBirth.text).toUtc()
                          );
                          final sql = SqlConnect();
                          await sql.sqlInitial();
                          final querystr ='UPDATE `x` SET `name` = ?, `addr` = ?, `birth` = ? WHERE `x`.`id` = ?;';
                          await sql.conn.query(querystr, [edit.name, edit.addr, edit.birth.toUtc(), edit.id]);
                          sql.conn.close();
                          setState((){
                            widget.data[widget.index].id=widget.data[widget.index].id;
                            widget.data[widget.index].name=txtName.text;
                            widget.data[widget.index].addr=txtAddr.text;
                            widget.data[widget.index].birth=DateTime.parse(txtBirth.text);
                          });
                          showDialog(
                            context: context, 
                            builder: (context)=>AlertDialog(
                              content: Text('修改完畢，按下確定後3秒後將跳回主頁面'),
                              actions: [
                                ElevatedButton(
                                  child: Text('確定'),
                                  onPressed: (){
                                    Future.delayed(
                                      Duration(seconds: 3),
                                      ()=>Navigator.popAndPushNamed(context, '/') //先直接跳回主頁面，如何在修改完時直接變動顯示日後再議
                                    );
                                  },
                                )
                              ],
                            )
                          );
                      }
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('取消'),
                    onPressed: () => Navigator.of(context).pop()
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
