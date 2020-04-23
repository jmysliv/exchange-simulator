import 'package:equatable/equatable.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';

abstract class CurrencyDetailEvent extends Equatable{
  const CurrencyDetailEvent();

  @override
  List<Object> get props => [];
}

class InitCurrencyDetail extends CurrencyDetailEvent{
  final String id;

  InitCurrencyDetail(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'InitCurrencyDetail:  $id';
}

class RefreshCurrencyDetail extends CurrencyDetailEvent{
  final Currency currency;
  final double amountOfPLN;

  RefreshCurrencyDetail(this.currency, this.amountOfPLN);

  @override
  List<Object> get props => [currency, amountOfPLN];

  @override
  String toString() => 'RefreshCurrencyDetail:  $currency';
}

class BuyCurrency extends CurrencyDetailEvent{
  final Currency currency;
  final double amountOfPLN;
  final double amountInvestedPLN;

  BuyCurrency(this.currency, this.amountInvestedPLN, this.amountOfPLN);

  @override
  List<Object> get props => [currency, amountInvestedPLN, amountOfPLN];

  @override
  String toString() => 'BuyCurrency:  $amountInvestedPLN';
}