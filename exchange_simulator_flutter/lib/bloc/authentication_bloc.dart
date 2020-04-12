import 'package:bloc/bloc.dart';
import 'package:exchange_simulator_flutter/bloc/authentication.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  final UserRepository _userRepository;
  AuthenticationBloc(this._userRepository);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event,) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    try{
      yield Authenticated();
    } catch(_){
      yield Unauthenticated();
    }

  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}