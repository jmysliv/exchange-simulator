import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable{
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState{}

class RegisterLoading extends RegisterState{}

class RegisterSucceed extends RegisterState{}

class RegisterFailed extends RegisterState{}

class RegisterServerNotResponding extends RegisterState{}