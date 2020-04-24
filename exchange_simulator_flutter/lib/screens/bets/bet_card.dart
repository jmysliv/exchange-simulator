import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/screens/bets/arrow_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SoldBetCard extends StatelessWidget{
  final Bet bet;
  SoldBetCard(this.bet);

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading:  Container(
            padding: EdgeInsets.only(top: 13),
            child: Text("${bet.amountOfCurrency.roundToDouble()} ${bet.currencySymbol}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("${bet.amountInvestedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 13,), textAlign: TextAlign.center,),
                    Text("${DateFormat.yMd().format(bet.purchaseDate)}",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward, color: Colors.cyanAccent,),
              ),
              Expanded(
                flex: 1,
                child:  Column(
                  children: <Widget>[
                    Text("${bet.amountObtainedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 13,), textAlign: TextAlign.center,),
                    Text("${DateFormat.yMd().format(bet.soldDate)}",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8,), textAlign: TextAlign.center,)
                  ],
                ),
              )
            ],
          ),
          subtitle: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text("Zysk: ${(bet.amountObtainedPLN - bet.amountInvestedPLN).roundToDouble()}PLN",
                style: TextStyle(color: ((bet.amountObtainedPLN - bet.amountInvestedPLN) > 0) ? Colors.green : Colors.red,
                  fontStyle: FontStyle.italic, fontSize: 10,), textAlign: TextAlign.center,)
          ),
        ),
      ),
    );
  }
}


class ActiveBetCard extends StatelessWidget{
  final Bet bet;
  ActiveBetCard(this.bet);

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading: Container(
            padding: EdgeInsets.only(top: 13),
            child: Text("${bet.amountOfCurrency.roundToDouble()} ${bet.currencySymbol}",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          title:Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text("${bet.amountInvestedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 13,), textAlign: TextAlign.center,),
                    Text("${DateFormat.yMd().format(bet.purchaseDate)}",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ArrowAnimation(),
              ),
              Expanded(
                flex: 3,
                child:  Column(
                  children: <Widget>[
                    Text("${bet.potentialObtained.toStringAsFixed(2)} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 13,), textAlign: TextAlign.center,),
                    Text("przy obecnym kursie",style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8))
                  ],
                ),
              )
            ],
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text("Przesuń by sprzedać",
              style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 10,), textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}
