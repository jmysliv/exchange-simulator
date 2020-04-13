import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable{
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent{
  final String email;
  final String password;
  final String name;

  const RegisterButtonPressed(this.email, this.password, this.name);

  @override
  List<Object> get props => [email, password, name];

  @override
  String toString() {
    return 'RegisterButtonPressed { email: $email, password: $password, name: $name }';
  }
}