import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRepository{
  final UserRepository userRepository;
  static const url = "http://192.168.43.53:7000";

  CurrencyRepository(this.userRepository);

  Future<List<Currency>> fetchCurrencies() async{
    final response = await http.get(url + "/currencies", headers: userRepository.setUpHeaders());
    if(response.statusCode == 200){
      List<Currency> currencies = (jsonDecode(response.body) as List).map((currency) => Currency.fromJson(currency)).toList();
      return currencies;
    }else{
      throw Exception("Failed to fetch currencies");
    }
  }

  Future<Currency> fetchCurrency(String id) async{
    final response = await http.get(url + "/currencies/" + id, headers: userRepository.setUpHeaders());
    if(response.statusCode == 200){
      return Currency.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to fetch currency");
    }
  }
}