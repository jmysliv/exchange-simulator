import 'package:exchange_simulator_flutter/bloc/authentication.dart';
import 'package:exchange_simulator_flutter/bloc_delegate.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/home_screen.dart';
import 'package:exchange_simulator_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository)..add(AppStarted()),
        child: MyApp(userRepository))
      );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  MyApp(this._userRepository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Simulator',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan
      ),
      routes: {
        "/login": (context) => LoginScreen(),
        "/home": (context) => HomeScreen()
      },
      initialRoute: "/login",
    );
  }
}

