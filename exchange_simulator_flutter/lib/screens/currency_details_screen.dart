import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyDetailScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;
  final BetRepository _betRepository;
  final String id;

  CurrencyDetailScreen(this.id) :
        _currencyRepository = CurrencyRepository(UserRepository.getInstance()),
        _betRepository = BetRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyDetailBloc>(
        create: (context) =>
        CurrencyDetailBloc(_betRepository, _currencyRepository)..add(InitCurrencyDetail(id)),
        child: BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
            builder: (buildContext, state) {
              if (state is CurrencyDetailInitial)
                return LoadingScreen("Ładowanie pieniędzy na serwer...");
              else if (state is CurrencyDetailError)
                return ErrorScreen(state.message);
              else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Test"),
                  ),
                  body: Container(
                    child: Text("${(state as CurrencyDetailFetched).currency.getCurrentExchangeRate()}"),
                  ),
                );
              }
            }
        )
    );
  }
}