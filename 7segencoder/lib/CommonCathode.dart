import 'dart:async';
import 'package:flutter/material.dart';

class CommonCathode extends StatefulWidget {
  CommonCathode({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CommonCathodeState createState() => _CommonCathodeState();
}

class _CommonCathodeState extends State<CommonCathode> {
  var _segdata = [0, 0, 0, 0, 0, 0, 0, 0];
  var _segstate = [false, false, false, false, false, false, false, false];
  var _out = "00";

  @override
  void initState()  //類似於.net Winform 的 Formload method
  {
    super.initState();
    //可重複使用的Timer
    Timer.periodic(Duration(milliseconds: 1), (timer){
      int x = 0;
      for(var i in _segdata)
        x|=i;

      if(x>15)
        _out = x.toRadixString(16).toString().toUpperCase();
      else
        _out ="0"+x.toRadixString(16).toString().toUpperCase();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                children: [
                  SizedBox(
                      width: 130,
                      height: 45,
                      child: ElevatedButton(
                        child: Text("a",style: TextStyle(fontSize: 30, color: Colors.white)),
                        onPressed: (){
                          setState(() {
                            _segstate[0] = !_segstate[0];
                            _segdata[0] = _segstate[0] ? 0x01 : 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: _segstate[0] ? Colors.red : Colors.black //Backcolor
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 45,
                          height: 130,
                          child: ElevatedButton(
                            child: Text("f",style: TextStyle(fontSize: 30, color: Colors.white)),
                            onPressed: (){
                              setState(() {
                                _segstate[5] = !_segstate[5];
                                _segdata[5] = _segstate[5] ? 0x20 : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: _segstate[5] ? Colors.red : Colors.black //Backcolor
                            ),
                          )
                      ),
                      SizedBox(
                          width: 45,
                          height: 130,
                          child: ElevatedButton(
                            child: Text("b",style: TextStyle(fontSize: 30, color: Colors.white)),
                            onPressed: (){
                              setState(() {
                                _segstate[1] = !_segstate[1];
                                _segdata[1] = _segstate[1] ? 0x02 : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: _segstate[1] ? Colors.red : Colors.black) //Backcolor
                            ,
                          )
                      )
                    ],
                  ),
                  SizedBox(
                      width: 130,
                      height: 45,
                      child: ElevatedButton(
                        child: Text("g",style: TextStyle(fontSize: 30, color: Colors.white)),
                        onPressed: (){
                          setState(() {
                            _segstate[6] = !_segstate[6];
                            _segdata[6] = _segstate[6] ? 0x40 : 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: _segstate[6] ? Colors.red : Colors.black //Backcolor
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 45,
                          height: 130,
                          child: ElevatedButton(
                            child: Text("e",style: TextStyle(fontSize: 30, color: Colors.white)),
                            onPressed: (){
                              setState(() {
                                _segstate[4] = !_segstate[4];
                                _segdata[4] = _segstate[4] ? 0x10 : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: _segstate[4] ? Colors.red : Colors.black //Backcolor
                            ),
                          )
                      ),
                      SizedBox(
                          width: 45,
                          height: 130,
                          child: ElevatedButton(
                            child: Text("c",style: TextStyle(fontSize: 30, color: Colors.white)),
                            onPressed: (){
                              setState(() {
                                _segstate[2] = !_segstate[2];
                                _segdata[2] = _segstate[2] ? 0x04 : 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: _segstate[2] ? Colors.red : Colors.black //Backcolor
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 80),
                        child: SizedBox(
                            width: 130,
                            height: 45,
                            child: ElevatedButton(
                              child: Text("d",style: TextStyle(fontSize: 30, color: Colors.white)),
                              onPressed: (){
                                setState(() {
                                  _segstate[3] = !_segstate[3];
                                  _segdata[3] = _segstate[3] ? 0x08 : 0;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: _segstate[3] ? Colors.red : Colors.black //Backcolor
                              ),
                            )
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35, 15, 0, 0),
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: ElevatedButton(
                                child: Text(".",style: TextStyle(fontSize: 30, color: Colors.white)),
                                onPressed: (){
                                  setState(() {
                                    _segstate[7] = !_segstate[7];
                                    _segdata[7] = _segstate[7] ? 0x80 : 0;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: _segstate[7] ? Colors.red : Colors.black //Backcolor
                                ),
                              )
                          )
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 2.5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text("0x$_out", style: TextStyle(fontSize: 40))
                      )
                  ),

                  //下面的程式碼為觀測數值用
                  // Text("a->${_segdata[0]} b->${_segdata[1]} c->${_segdata[2]} d->${_segdata[3]}",style: TextStyle(fontSize: 15)),
                  // Text("e->${_segdata[4]} f->${_segdata[5]} g->${_segdata[6]} .->${_segdata[7]}",style: TextStyle(fontSize: 15))
                ]
            )
        )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}