import 'package:exchange_simulator_flutter/bloc/register/register.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/register/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';

class RegisterScreen extends StatelessWidget{


  RegisterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Załóż konto')),
        body: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(UserRepository.getInstance()),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state){
              if(state is RegisterServerNotResponding){
                Navigator.of(context).pop();
                BlocProvider.of<AuthenticationBloc>(context).add(ServerTimeout());
              }
              else if (state is RegisterFailed) {
                Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text('Podany email jest zajęty', style: TextStyle(color: Colors.white)),
                      Icon(Icons.error)],
                    ),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              else if (state is RegisterSucceed) {
                Navigator.of(context).pop();
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              }
              else if(state is RegisterLoading){
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
                  )
                );
              }
            },
            child: Builder(
              builder: (cxt){
              return RegisterForm();
            },

          ),
        )
      )
    );
  }

}