import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';

class HomeScreen extends StatelessWidget{

  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: <Widget>[
              Text("Home screen"),
              RaisedButton(
                onPressed: (){
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  Navigator.of(context).pushReplacementNamed("/login");
                },
              )
            ],
          )
      ),
    );
  }
}