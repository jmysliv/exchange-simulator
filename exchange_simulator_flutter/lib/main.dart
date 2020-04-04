import 'package:exchange_simulator_flutter/bloc_delegate.dart';
import 'package:exchange_simulator_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Simulator',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan
      ),
      home: LoginScreen(),
    );
  }
}

