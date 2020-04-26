import 'package:exchange_simulator_flutter/bloc/currency/currency.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/currency_list/currencies_list.dart';
import 'package:exchange_simulator_flutter/screens/splash/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/splash/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrenciesScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;

  CurrenciesScreen() :
        _currencyRepository = CurrencyRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyBloc>(
        create: (context) =>
        CurrencyBloc(_currencyRepository)
          ..add(InitCurrency()),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (buildContext, state) {
              if (state is CurrencyInitial)
                return LoadingScreen("Ładowanie pieniędzy na serwer...");
              else if (state is CurrencyError)
                return ErrorScreen(state.message);
              else {
                return CurrenciesList((state as CurrencyFetched).currencies);
              }
            }
        )
    );
  }
}


