import 'package:exchange_simulator_flutter/bloc/currency/currency.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrenciesScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;

  CurrenciesScreen() :
    _currencyRepository = CurrencyRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyBloc>(
        create: (context) => CurrencyBloc(_currencyRepository)..add(InitCurrency()),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (buildContext, state) {
            if(state is CurrencyInitial) return LoadingScreen("Ładowanie pieniędzy na serwer...");
            if(state is CurrencyError) return ErrorScreen(state.message);
            else{
              return currenciesList(context);
            }
          }
        )
    );
  }

  Widget currenciesList(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Waluty"),
      ),
      drawer: HomeDrawer(),
    );
  }
}