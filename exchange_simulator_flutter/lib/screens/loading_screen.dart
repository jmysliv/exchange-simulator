import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  final String message;
  LoadingScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message, style: TextStyle(color: Colors.white, fontSize: 30),)
      ),
    );
  }
}