import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/register/register.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  final UserRepository _userRepository;
  RegisterBloc(this._userRepository);

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if(event is RegisterButtonPressed){
      yield RegisterLoading();
      try{
        await _userRepository.register(event.email, event.name, event.password).timeout(Duration(seconds: 5));
        yield RegisterSucceed();
      } catch( exception){
        if(exception is TimeoutException) yield RegisterServerNotResponding();
        else yield RegisterFailed();
      }
    }
  }
}