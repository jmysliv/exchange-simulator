import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/bet/bet.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';

class BetBloc extends Bloc<BetEvent, BetState> {
  final BetRepository _betRepository;
  final CurrencyRepository _currencyRepository;

  BetBloc(this._betRepository, this._currencyRepository);

  @override
  BetState get initialState => BetInitial();

  @override
  Stream<BetState> mapEventToState(BetEvent event) async* {
    if (event is InitBet) {
      try {
        List<Bet> bets = await _betRepository.fetchBets().timeout(Duration(seconds: 5));
        calculatePotentialOutcome(bets);
        await Future.delayed(Duration(seconds: 3));
        yield BetFetched(bets);
      } catch (exception) {
        if (exception is TimeoutException)
          yield BetError(
              "Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          await Future.delayed(Duration(seconds: 3));
          yield BetError(exception.toString());
        }
      }
    } else if (event is RefreshBet) {
      try {
        yield BetLoading(event.oldBets);
        List<Bet> bets = await _betRepository.fetchBets().timeout(Duration(seconds: 5));
        calculatePotentialOutcome(bets);
        yield BetFetched(bets);
      } catch (exception) {
        if (exception is TimeoutException)
          yield BetError(
              "Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          yield BetError(exception.toString());
        }
      }
    } else if (event is SellBet) {
      try {
        yield BetLoading(event.oldBets.where( (bet) => bet.id != event.betId).toList());
        await _betRepository.sellCurrency(event.betId);
        List<Bet> bets = await _betRepository.fetchBets().timeout(Duration(seconds: 5));
        calculatePotentialOutcome(bets);
        yield BetFetched(bets);
      } catch (exception) {
        if (exception is TimeoutException)
          yield BetError(
              "Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else {
          yield BetError(exception.toString());
        }
      }
    }
  }

  void calculatePotentialOutcome(List<Bet> bets) async{
    List<Currency> currencies = await _currencyRepository.fetchCurrencies().timeout(Duration(seconds: 5));
    bets.forEach((bet) => bet.calculatePotentialOutcome(currencies));
  }
}