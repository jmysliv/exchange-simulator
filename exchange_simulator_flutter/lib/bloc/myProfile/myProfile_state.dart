import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';

abstract class MyProfileState extends Equatable{
  const MyProfileState();
  @override
  List<Object> get props => [];
}

class MyProfileInitial extends MyProfileState{}


class MyProfileFetched extends MyProfileState{
  final User user;

  MyProfileFetched(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'MyProfileFetched:  $user';
}

class MyProfileError extends MyProfileState{
  final String message;
  MyProfileError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MyProfileError:  $message';
}