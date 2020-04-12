import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          builder: (context, state) {
            if (state is Uninitialized){
              return LoadingScreen("ładowanie danych");
            } else if(state is ServerNotResponding){
              return LoadingScreen("Server chwilowo nie działa");
            } else {
              return loginForm(context);
            }
          },
        )
    );
  }

  Widget loginForm(BuildContext context){
    return Scaffold(
      body: Center(
        child: new SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 250.0,
                      child: Image.asset(
                        "assets/images/logo_transparent.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      obscureText: false,
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15.0),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              15.0, 10.0, 15.0, 10.0),
                          hintText: "Email",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Pole nie może być puste";
                        }
                        if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Niepoprawny format email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15.0),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              15.0, 10.0, 15.0, 10.0),
                          hintText: "Hasło",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Pole nie może być puste";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black,
                      child: MaterialButton(
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            15.0, 10.0, 15.0, 10.0),
                        onPressed: (){
                          _formKey.currentState.validate();
                        },
                        child: Text("Zaloguj",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 15.0)
                                .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black,
                      child: MaterialButton(
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            15.0, 10.0, 15.0, 10.0),
                        onPressed: () {
                          Navigator.push(context, PageTransition(type: PageTransitionType.downToUp,child: RegisterScreen()));
                        },
                        child: Text("Załóż konto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 15.0)
                                .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}