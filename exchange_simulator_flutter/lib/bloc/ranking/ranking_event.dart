import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';

abstract class RankingEvent extends Equatable{
  const RankingEvent();

  @override
  List<Object> get props => [];
}

class InitRanking extends RankingEvent{}

class RefreshRanking extends RankingEvent{
  final List<User> oldUsers;

  RefreshRanking(this.oldUsers);

  @override
  List<Object> get props => [oldUsers];

  @override
  String toString() => 'RefreshRanking:  $oldUsers';
}

