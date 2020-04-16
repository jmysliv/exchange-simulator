import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/ranking/ranking.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState>{
  final UserRepository _userRepository;
  RankingBloc(this._userRepository);

  @override
  RankingState get initialState => RankingInitial();

  @override
  Stream<RankingState> mapEventToState(RankingEvent event) async* {
    if(event is InitRanking){
      try{
        List<User> users = await _userRepository.fetchUsers().timeout(Duration(seconds: 5));
        users.sort((User a, User b) => b.amountOfPLN.compareTo(a.amountOfPLN));
        await Future.delayed(Duration(seconds: 3));
        yield RankingFetched(users);
      } catch( exception){
        if(exception is TimeoutException) yield RankingError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else{
          await Future.delayed(Duration(seconds: 3));
          yield RankingError(exception.toString());
        }
      }
    } else if(event is RefreshRanking){
      try{
        yield RankingLoading(event.oldUsers);
        List<User> users = await _userRepository.fetchUsers().timeout(Duration(seconds: 5));
        users.sort((User a, User b) => b.amountOfPLN.compareTo(a.amountOfPLN));
        yield RankingFetched(users);
      } catch( exception){
        if(exception is TimeoutException) yield RankingError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else{
          yield RankingError(exception.toString());
        }
      }
    }
  }
}