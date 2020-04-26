import 'package:exchange_simulator_flutter/bloc/ranking/ranking.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/ranking/ranking_list.dart';
import 'package:exchange_simulator_flutter/screens/splash/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/splash/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingScreen extends StatelessWidget {

  RankingScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RankingBloc>(
      create: (context) =>
      RankingBloc(UserRepository.getInstance())
        ..add(InitRanking()),
      child: BlocBuilder<RankingBloc, RankingState>(
        builder: (buildContext, state) {
          if (state is RankingInitial)
            return LoadingScreen("Ładowanie pieniędzy na serwer...");
          else if (state is RankingError)
            return ErrorScreen(state.message);
          else {
            List<User> users;
            if(state is RankingFetched) users = state.users;
            else users = (state as RankingLoading).oldUsers;
            return RankingList(users);
          }
        },
      ),
    );
  }
}