import 'dart:convert';

import 'package:exchange_simulator_flutter/models/currency_model.dart';

class Bet {
  String id;
  String currencyId;
  String userId;
  String currencySymbol;
  double amountOfCurrency;
  DateTime purchaseDate;
  DateTime soldDate;
  double amountInvestedPLN;
  double amountObtainedPLN;
  double potentialObtained = 0.0;

  Bet(this.id, this.currencyId, this.userId, this.currencySymbol, this.amountOfCurrency, this.purchaseDate, this.soldDate, this.amountInvestedPLN, this.amountObtainedPLN);

  Bet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currencyId = json['currencyId'];
    userId = json['userId'];
    currencySymbol = json['currencySymbol'];
    amountOfCurrency = json['amountOfCurrency'];
    purchaseDate = DateTime.parse(json['purchaseDate']);
    soldDate = (json['soldDate'] == null) ? null : DateTime.parse(json['soldDate']);
    amountInvestedPLN = json['amountInvestedPLN'];
    amountObtainedPLN = (json['amountObtainedPLN'] == "NaN") ? 0 : json['amountObtainedPLN'];
  }

  void calculatePotentialOutcome(List<Currency> currencies){
    if(this.soldDate != null) return;
    for(Currency currency in currencies){
      if(currency.id == this.currencyId){
        potentialObtained = this.amountOfCurrency * currency.getCurrentExchangeRate();
        return;
      }
    }
  }

  @override
  String toString() => '{ id: $id , currencyId: $currencyId, userId: $userId, currencySymbol: $currencySymbol, amountOfCurrency: $amountOfCurrency, purchaseDate: $purchaseDate, '
      'soldDate: $soldDate, amountInvestedPLN: $amountInvestedPLN, amountObtainedPLN: $amountObtainedPLN}';

}

class BuyCurrency{
  String currencyId;
  double amountInvestedPLN;

  BuyCurrency(this.currencyId, this.amountInvestedPLN);

  String toJson() =>
      jsonEncode({
        "currencyId": "$currencyId",
        "amountInvestedPLN": "$amountInvestedPLN"
      });

  @override
  String toString() => '{ currencyId: $currencyId, amountInvestedPLN: $amountInvestedPLN}';
}