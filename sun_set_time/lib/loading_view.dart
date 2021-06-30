import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadgingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Text(
          '載入中',
          style: TextStyle(fontSize: 20)
        )
      ]
    );
  }
}