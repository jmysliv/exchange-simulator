import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{

  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: HomeDrawer(),
      body: Center(
          child: Column(
            children: <Widget>[
              Text("Home screen"),
            ],
          )
      ),
    );
  }
}