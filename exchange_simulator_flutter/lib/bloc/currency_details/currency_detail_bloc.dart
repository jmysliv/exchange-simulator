import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';

class CurrencyDetailBloc extends Bloc<CurrencyDetailEvent, CurrencyDetailState> {
  final BetRepository _betRepository;
  final CurrencyRepository _currencyRepository;
  final UserRepository _userRepository;

 CurrencyDetailBloc(this._betRepository, this._currencyRepository, this._userRepository);

  @override
  CurrencyDetailState get initialState => CurrencyDetailInitial();

  @override
  Stream<CurrencyDetailState> mapEventToState(CurrencyDetailEvent event) async* {
    if (event is InitCurrencyDetail) {
      try {
        Currency currency = await _currencyRepository.fetchCurrency(event.id).timeout(Duration(seconds: 5));
        currency.timestamps.sort( (Timestamp a, Timestamp b) => a.date.compareTo(b.date));
        double amount = (await _userRepository.fetchMe().timeout(Duration(seconds: 5))).amountOfPLN;
        yield CurrencyDetailFetched(currency, amount);
      } catch (exception) {
        if (exception is TimeoutException)
          yield CurrencyDetailError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          yield CurrencyDetailError(exception.toString());
        }
      }
    } else if (event is RefreshCurrencyDetail) {
      try {
        yield CurrencyDetailLoading(event.currency, event.amountOfPLN);
        Currency currency = await _currencyRepository.fetchCurrency(event.currency.id).timeout(Duration(seconds: 5));
        currency.timestamps.sort( (Timestamp a, Timestamp b) => a.date.compareTo(b.date));
        double amount = (await _userRepository.fetchMe().timeout(Duration(seconds: 5))).amountOfPLN;
        yield CurrencyDetailFetched(currency, amount);
      } catch (exception) {
        if (exception is TimeoutException)
          yield CurrencyDetailError(
              "Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          yield CurrencyDetailError(exception.toString());
        }
      }
    } else if (event is BuyCurrency) {
      try {
        yield CurrencyDetailLoading(event.currency, event.amountOfPLN - event.amountInvestedPLN);
        await _betRepository.buyCurrency(event.currency.id, event.amountInvestedPLN);
        Currency currency = await _currencyRepository.fetchCurrency(event.currency.id).timeout(Duration(seconds: 5));
        currency.timestamps.sort( (Timestamp a, Timestamp b) => a.date.compareTo(b.date));
        double amount = (await _userRepository.fetchMe().timeout(Duration(seconds: 5))).amountOfPLN;
        yield CurrencyBought(currency, amount);
      } catch (exception) {
        if (exception is TimeoutException) yield  CurrencyDetailError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          yield CurrencyDetailError(exception.toString());
        }
      }
    }
  }

}