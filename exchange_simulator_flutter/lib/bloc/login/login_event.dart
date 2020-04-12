import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent{
  final String email;
  final String password;

  const LoginButtonPressed(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginButtonPressed { email: $email, password: $password }';
  }
}