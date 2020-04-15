import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';
import 'package:exchange_simulator_flutter/bloc_delegate.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/currencies_screen.dart';
import 'package:exchange_simulator_flutter/screens/home_screen.dart';
import 'package:exchange_simulator_flutter/screens/login_screen.dart';
import 'package:exchange_simulator_flutter/screens/myprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(UserRepository.getInstance())..add(AppStarted()),
        child: MyApp())
      );
}

class MyApp extends StatelessWidget {

  MyApp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child:MaterialApp(
        title: 'Currency Exchange Simulator',
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.cyan,
        ),
        routes: {
          "/login": (context) => LoginScreen(),
          "/home": (context) => HomeScreen(),
          "/currencies": (context) => CurrenciesScreen(),
          "/my-profile": (context) => MyProfileScreen()
        },
        initialRoute: "/login",
      )
    );
  }
}

