import 'dart:convert';
import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/models/exceptions.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:http/http.dart' as http;


class BetRepository{
  static const url = "http://192.168.43.53:7000";
  final UserRepository _userRepository;

  BetRepository(this._userRepository);

  Future<void> buyCurrency(String currencyId, double amountInvestedPLN) async{
    BuyCurrency buyCurrency = BuyCurrency(currencyId, amountInvestedPLN);
    final response = await http.post(url + "/bets", headers: _userRepository.setUpHeaders(), body: buyCurrency.toJson());
    if(response.statusCode == 200){
      return;
    } else if(response.statusCode == 409){
      throw NotEnoughMoneyException();
    } else if(response.statusCode == 400){
      throw Exception(jsonDecode(response.body)['message']);
    } else{
      throw Exception("Failed to buy currency");
    }
  }

  Future<List<Bet>> fetchBets() async{
    final response = await http.get(url + "/bets", headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      List<Bet> bets = (jsonDecode(response.body) as List).map((bet) => Bet.fromJson(bet)).toList();
      return bets;
    }else{
      throw Exception("Failed to fetch bets");
    }
  }

  Future<Bet> fetchBet(String id) async{
    final response = await http.get(url + "/bets/" + id, headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      Bet bet = Bet.fromJson(jsonDecode(response.body));
      return bet;
    }else if(response.statusCode == 400) {
      throw Exception("Inwestycja należy do innego użytkownika");
    }else {
      throw Exception("Failed to fetch bet");
    }
  }

  Future<void> sellCurrency(String betId) async{
    final response = await http.put(url + "/bets/" + betId, headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      return;
    } else if(response.statusCode == 409){
      throw Exception("Waluta została już sprzedana");
    } else if(response.statusCode == 400){
      throw Exception(jsonDecode(response.body)['message']);
    } else{
      throw Exception("Failed to sell currency");
    }
  }


}