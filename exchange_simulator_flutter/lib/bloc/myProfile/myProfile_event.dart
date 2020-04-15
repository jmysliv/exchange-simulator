import 'package:equatable/equatable.dart';

abstract class MyProfileEvent extends Equatable{
  const MyProfileEvent();

  @override
  List<Object> get props => [];
}

class InitMyProfile extends MyProfileEvent{}

