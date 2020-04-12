import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/login/login.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final UserRepository _userRepository;
  LoginBloc(this._userRepository);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginButtonPressed){
      yield LoginLoading();
      try{
        await _userRepository.login(event.email, event.password).timeout(Duration(seconds: 5));
        yield LoginSucceed();
      } catch( exception){
        if(exception is TimeoutException) yield ServerNotResponding();
        else yield LoginFailed();
      }
    }
  }
}