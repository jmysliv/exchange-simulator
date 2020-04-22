import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';

abstract class BetEvent extends Equatable{
  const BetEvent();

  @override
  List<Object> get props => [];
}

class InitBet extends BetEvent{}

class RefreshBet extends BetEvent{
  final List<Bet> oldBets;

  RefreshBet(this.oldBets);

  @override
  List<Object> get props => [oldBets];

  @override
  String toString() => 'RefreshBet:  $oldBets';
}

class SellBet extends BetEvent{
  final List<Bet> oldBets;
  final String betId;

  SellBet(this.betId, this.oldBets);

  @override
  List<Object> get props => [oldBets, betId];

  @override
  String toString() => 'SellBett:  $betId';
}