import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSucceed extends LoginState{}

class LoginFailed extends LoginState{}

class LoginServerNotResponding extends LoginState{}