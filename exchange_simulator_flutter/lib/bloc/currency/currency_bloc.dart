import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/currency/currency.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState>{
  final CurrencyRepository _currencyRepository;
  CurrencyBloc(this._currencyRepository);

  @override
  CurrencyState get initialState => CurrencyInitial();

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if(event is FetchCurrency){
      yield CurrencyLoading(event.oldCurrencies);
      try{
        List<Currency> currencies = await _currencyRepository.fetchCurrencies().timeout(Duration(seconds: 5));
        if(event.name != null){
          currencies = currencies.where(
                  (value) => value.name
                  .toLowerCase()
                  .contains(event.name.toLowerCase())).toList();
        }
        yield CurrencyFetched(currencies);
      } catch( exception){
        if(exception is TimeoutException) yield CurrencyError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else yield CurrencyError(exception.toString());
      }
    } else if(event is InitCurrency){
      try{
        List<Currency> currencies = await _currencyRepository.fetchCurrencies().timeout(Duration(seconds: 5));
        await Future.delayed(Duration(seconds: 3));
        yield CurrencyFetched(currencies);
      } catch( exception){
        if(exception is TimeoutException) yield CurrencyError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else{
          await Future.delayed(Duration(seconds: 3));
          yield CurrencyError(exception.toString());
        }
      }
    }
  }
}