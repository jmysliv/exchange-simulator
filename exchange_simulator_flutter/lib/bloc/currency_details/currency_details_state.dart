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
  final double amountOfPLN;

  CurrencyDetailLoading(this.currency, this.amountOfPLN);

  @override
  List<Object> get props => [currency, amountOfPLN];

  @override
  String toString() => 'CurrencyDetailLoading:  $currency';
}


class CurrencyDetailFetched extends CurrencyDetailState {
  final Currency currency;
  final double amountOfPLN;

  CurrencyDetailFetched(this.currency, this.amountOfPLN);

  @override
  List<Object> get props => [currency, amountOfPLN];

  @override
  String toString() => 'CurrencyDetailFetched:  $currency';
}

class CurrencyBought extends CurrencyDetailState{
  final Currency currency;
  final double amountOfPLN;

  CurrencyBought(this.currency, this.amountOfPLN);

  @override
  List<Object> get props => [currency, amountOfPLN];

  @override
  String toString() => 'CurrencyBught:  $currency';
}

class CurrencyDetailError extends CurrencyDetailState{
  final String message;
  CurrencyDetailError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CurrencyDetailError:  $message';
}