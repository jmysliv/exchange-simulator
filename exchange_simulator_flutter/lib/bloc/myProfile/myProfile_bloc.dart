import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/myProfile/myProfile.dart';
import 'package:exchange_simulator_flutter/models/account_balance.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState>{
  final UserRepository _userRepository;
  final BetRepository _betRepository;
  MyProfileBloc(this._userRepository, this._betRepository);

  @override
  MyProfileState get initialState => MyProfileInitial();

  @override
  Stream<MyProfileState> mapEventToState(MyProfileEvent event) async* {
    if(event is InitMyProfile){
      try{
        User user = await _userRepository.fetchMe().timeout(Duration(seconds: 5));
        AccountBalance balance = AccountBalance.fromBets(await _betRepository.fetchBets().timeout(Duration(seconds: 5)));
        await Future.delayed(Duration(seconds: 3));
        yield MyProfileFetched(user, balance);
      } catch( exception){
        if(exception is TimeoutException) yield MyProfileError("Ups, serwer na razie nie odpowiada. Przepraszamy za niedogodności, już pracujemy nad rozwiązaniem!");
        else{
          await Future.delayed(Duration(seconds: 3));
          yield MyProfileError(exception.toString());
        }
      }
    }
  }
}