import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  
  String time;
  ResultView(this.time);


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '今日夕陽時間',
              style: TextStyle(fontSize: 18)
            ),
            Text(
              '$time',
              style: TextStyle(fontSize: 87)
            ),
          ],
        ),
      );
  }
}