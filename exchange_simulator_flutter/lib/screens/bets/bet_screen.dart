import 'package:exchange_simulator_flutter/bloc/bet/bet.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/bets/bet_list.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BetScreen extends StatelessWidget {
  final BetRepository _betRepository;

  BetScreen() :
        _betRepository = BetRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<BetBloc>(
        create: (context) =>
        BetBloc(_betRepository, CurrencyRepository(UserRepository.getInstance()))..add(InitBet()),
        child: BlocBuilder<BetBloc, BetState>(
            builder: (buildContext, state) {
              if (state is BetInitial)
                return LoadingScreen("Ładowanie pieniędzy na serwer...");
              else if (state is BetError)
                return ErrorScreen(state.message);
              else {
                List<Bet> bets;
                if(state is BetLoading) bets = state.oldBets;
                if(state is BetFetched) bets = state.bets;
                return BetsList(bets);
              }
            }
        )
    );
  }
}



