import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable{
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class InitCurrency extends CurrencyEvent{}

class FetchCurrency extends CurrencyEvent{
  final String name;
  FetchCurrency({String name}): this.name = name;

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'FetchCurrency:  $name';
}
