import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';

abstract class CurrencyEvent extends Equatable{
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class InitCurrency extends CurrencyEvent{}

class FetchCurrency extends CurrencyEvent{
  final String name;
  final List<Currency> oldCurrencies;
  FetchCurrency(this.oldCurrencies, {String name}): this.name = name;

  @override
  List<Object> get props => [name, oldCurrencies];

  @override
  String toString() => 'FetchCurrency:  $name';
}
