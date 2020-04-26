import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';
import 'package:exchange_simulator_flutter/bloc/login/login.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/splash/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/splash/loading_screen.dart';
import 'package:exchange_simulator_flutter/screens/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget{

  LoginScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed("/home");
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (buildContext, state) {
            if (state is Uninitialized){
              return LoadingScreen("Ładowanie pieniędzy na serwer...");
            } else if(state is ServerNotResponding){
              return ErrorScreen("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
            } else {
              return Scaffold(
                body: BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(UserRepository.getInstance()),
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state){
                      if(state is LoginServerNotResponding){
                        BlocProvider.of<AuthenticationBloc>(context).add(ServerTimeout());
                      }
                      else if (state is LoginFailed) {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Podane dane są nieprawidłowe', style: TextStyle(color: Colors.white)),
                                Icon(Icons.error)],
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                      else if (state is LoginSucceed) {
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                      }
                      else if(state is LoginLoading){
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Logowanie, prosze czekać', style: TextStyle(color: Colors.white)),
                                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent))
                              ],
                            ),
                            backgroundColor: Colors.black,
                            duration: Duration(seconds: 5),
                        ));
                      }
                    },
                    child: Builder(
                      builder: (cxt){
                        return LoginForm();
                      },
                    )
                ))
            );
            }
          },
        ),
    );
  }


}