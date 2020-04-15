import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';

abstract class CurrencyState extends Equatable{
  const CurrencyState();
  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState{}

class CurrencyLoading extends CurrencyState{
  final List<Currency> oldCurrencies;

  CurrencyLoading(this.oldCurrencies);

  @override
  List<Object> get props => [oldCurrencies];

  @override
  String toString() => 'CurrencyLoading:  $oldCurrencies';
}

class CurrencyFetched extends CurrencyState{
  final List<Currency> currencies;

  CurrencyFetched(this.currencies);

  @override
  List<Object> get props => [currencies];

  @override
  String toString() => 'CurrencyFetched:  $currencies';
}

class CurrencyError extends CurrencyState{
  final String message;
   CurrencyError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CurrencyError:  $message';
}