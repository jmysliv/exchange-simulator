import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';

abstract class RankingState extends Equatable{
  const RankingState();
  @override
  List<Object> get props => [];
}

class RankingInitial extends RankingState{}

class RankingLoading extends RankingState{
  final List<User> oldUsers;

  RankingLoading(this.oldUsers);

  @override
  List<Object> get props => [oldUsers];

  @override
  String toString() => 'RankingLoading:  $oldUsers';
}


class RankingFetched extends RankingState{
  final List<User> users;

  RankingFetched(this.users);

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'RankingFetched:  $users';
}

class RankingError extends RankingState{
  final String message;
  RankingError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RankingError:  $message';
}