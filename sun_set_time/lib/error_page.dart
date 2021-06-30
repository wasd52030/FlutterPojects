import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {

  VoidCallback onRefshButtonClick;

  ErrorView({this.onRefshButtonClick}){}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_off),
        ElevatedButton(
          child: Text('重新載入'),
          onPressed: (){
            onRefshButtonClick();
          },
        )
      ],
    );
  }
}