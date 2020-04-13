import 'package:exchange_simulator_flutter/bloc/register/register.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';

class RegisterScreen extends StatelessWidget{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository;

  RegisterScreen(this._userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Załóż konto')),
        body: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(_userRepository),
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
              return registerForm(cxt);
            },

          ),
        )
      )
    );
  }

  Widget registerForm(BuildContext context){
    return Center(
      child: new SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                    child: Image.asset(
                      "assets/images/logo_transparent.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    obscureText: false,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 15.0),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            15.0, 10.0, 15.0, 10.0),
                        hintText: "Nazwa użytkownika",
                        border:
                        OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Pole nie może być puste";
                      }
                      if (value.length > 20) {
                        return "Nazwa może mieć maksymalnie 20 znaków";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
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
                      if(value.length > 40){
                        return "Email nie może być dłuższy niż 40 znaków";
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
                      if(value.length < 8){
                        return "Hasło musi mieć co najmniej 8 znaków";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: true,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 15.0),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            15.0, 10.0, 15.0, 10.0),
                        hintText: "Powtórz hasło",
                        border:
                        OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Pole nie może być puste";
                      }
                      if(value != _passwordController.text){
                        return "Hasła nie są identyczne";
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
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          BlocProvider.of<RegisterBloc>(context)
                              .add(RegisterButtonPressed(_emailController.text,  _passwordController.text, _nameController.text));
                        }
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
    );
  }
}