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

  RefreshCurrencyDetail(this.currency);

  @override
  List<Object> get props => [currency];

  @override
  String toString() => 'RefreshCurrencyDetail:  $currency';
}

class BuyCurrency extends CurrencyDetailEvent{
  final Currency currency;
  final double amountInvestedPLN;

  BuyCurrency(this.currency, this.amountInvestedPLN);

  @override
  List<Object> get props => [currency, amountInvestedPLN];

  @override
  String toString() => 'BuyCurrency:  $amountInvestedPLN';
}