import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';


abstract class CurrencyDetailState extends Equatable{
  const CurrencyDetailState();
  @override
  List<Object> get props => [];
}

class CurrencyDetailInitial extends CurrencyDetailState{}

class CurrencyDetailLoading extends CurrencyDetailState{
  final Currency currency;

  CurrencyDetailLoading(this.currency);

  @override
  List<Object> get props => [currency];

  @override
  String toString() => 'CurrencyDetailLoading:  $currency';
}


class CurrencyDetailFetched extends CurrencyDetailState {
  final Currency currency;

  CurrencyDetailFetched(this.currency);

  @override
  List<Object> get props => [currency];

  @override
  String toString() => 'CurrencyDetailFetched:  $currency';
}

class NotEnoughMoney extends CurrencyDetailState{
  final Currency currency;

  NotEnoughMoney(this.currency);

  @override
  List<Object> get props => [currency];

  @override
  String toString() => 'NotEnoughMoney:  $currency';
}

class CurrencyDetailError extends CurrencyDetailState{
  final String message;
  CurrencyDetailError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CurrencyDetailError:  $message';
}