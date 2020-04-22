import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';

abstract class BetState extends Equatable{
  const BetState();
  @override
  List<Object> get props => [];
}

class BetInitial extends BetState{}

class BetLoading extends BetState{
  final List<Bet> oldBets;

  BetLoading(this.oldBets);

  @override
  List<Object> get props => [oldBets];

  @override
  String toString() => 'BetLoading:  $oldBets';
}


class BetFetched extends BetState{
  final List<Bet> bets;

  BetFetched(this.bets);

  @override
  List<Object> get props => [bets];

  @override
  String toString() => 'BetFetched:  $bets';
}

class BetError extends BetState{
  final String message;
  BetError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'BetError:  $message';
}