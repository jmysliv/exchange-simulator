import 'package:exchange_simulator_flutter/models/bet_model.dart';

class BalanceTimestamp{
  final DateTime date;
  double amountOfPLN;

  BalanceTimestamp(this.date, this.amountOfPLN);

  @override
  String toString() => "BalanceTimestamp: {date: $date, amountOfPLN: $amountOfPLN}";
}

class AccountBalance{
  List<BalanceTimestamp> balanceTimestamps;

  AccountBalance.fromBets(List<Bet> bets){
    List<BalanceTimestamp> timestamps = List<BalanceTimestamp>();
    bets.forEach( (bet) {
      timestamps.add(BalanceTimestamp(bet.purchaseDate, -bet.amountInvestedPLN));
      if(bet.soldDate != null){
        timestamps.add(BalanceTimestamp(bet.soldDate, bet.amountObtainedPLN));
      }
    });
    timestamps.sort((BalanceTimestamp a, BalanceTimestamp b) => a.date.compareTo(b.date));
    double currentBalance = 1000;
    timestamps.forEach((timestamp){
      currentBalance += timestamp.amountOfPLN;
      timestamp.amountOfPLN = currentBalance;
    });
    timestamps.add(BalanceTimestamp(timestamps[0].date.subtract(Duration(days: 1)), 1000));
    timestamps.sort((BalanceTimestamp a, BalanceTimestamp b) => a.date.compareTo(b.date));
    balanceTimestamps = timestamps;
    print(balanceTimestamps);
  }

  String userStatus(){
    int number = balanceTimestamps.length;
    if(number > 25) return "Giełdowy wyjadacz";
    else if(number > 20) return "Doświadczony inwestor";
    else if(number > 15) return "Znawca walut";
    else if(number > 10) return "Amator";
    else if(number > 5) return "Początkujący inwestor";
    else return "Laik giełdowy";
  }

}