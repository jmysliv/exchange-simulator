import 'package:exchange_simulator_flutter/bloc/bet/bet.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class BetScreen extends StatelessWidget {
  final BetRepository _betRepository;

  BetScreen() :
        _betRepository = BetRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<BetBloc>(
        create: (context) =>
        BetBloc(_betRepository)..add(InitBet()),
        child: BlocBuilder<BetBloc, BetState>(
            builder: (buildContext, state) {
              if (state is BetInitial)
                return LoadingScreen("Ładowanie pieniędzy na serwer...");
              else if (state is BetError)
                return ErrorScreen(state.message);
              else {
                List<Bet> bets;
                if(state is BetLoading) bets = state.oldBets;
                if(state is BetFetched) bets = state.bets;
                return BetsList(bets);
              }
            }
        )
    );
  }
}

class BetsList extends StatefulWidget {
  final List<Bet> bets;
  BetsList(this.bets);

  State<BetsList> createState() => _BetsListState();
}

class _BetsListState extends State<BetsList>{
  List<Bet> _filteredBets;

  @override
  void initState() {
    super.initState();
    _filteredBets = widget.bets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Moje Inwestycje"),
        ),
        drawer: HomeDrawer(),
        body: RefreshIndicator(
          onRefresh: (){
            BlocProvider.of<BetBloc>(context).add(RefreshBet(widget.bets));
            return Future.delayed(Duration(seconds: 0));
          },
          child: BlocListener<BetBloc, BetState>(
            listener: (context, state){
              if (state is BetLoading){
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ładowanie...', style: TextStyle(color: Colors.white)),
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent))
                          ],
                        ),
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 5),
                      ));
              } else{
                Scaffold.of(context).hideCurrentSnackBar();
              }
            },
            child: Container(
                child: Center(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredBets.length,
                        itemBuilder: (context, index) {
                          if(_filteredBets[index].soldDate == null){
                            return activeBetCard(context, _filteredBets[index]);
                          } else{
                            return soldBetCard(context, _filteredBets[index]);
                          }
                        })
                )
            )
          )
        )
    );
  }

  Widget soldBetCard(BuildContext context, Bet bet){
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading: Text("${bet.amountOfCurrency.roundToDouble()} ${bet.currencySymbol}",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("${bet.amountInvestedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 15,), textAlign: TextAlign.center,),
                    Text("${DateFormat.yMd().format(bet.purchaseDate)}",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                flex: 1,
                child:  Column(
                  children: <Widget>[
                    Text("${bet.amountObtainedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 15,), textAlign: TextAlign.center,),
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
              style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 10,), textAlign: TextAlign.center,)
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget activeBetCard(BuildContext context, Bet bet){
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading: Text("${bet.amountOfCurrency.roundToDouble()} ${bet.currencySymbol}",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          title:Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("${bet.amountInvestedPLN.roundToDouble()} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 15,), textAlign: TextAlign.center,),
                    Text("${DateFormat.yMd().format(bet.purchaseDate)}",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                flex: 1,
                child:  Column(
                  children: <Widget>[
                    Text("${bet.amountObtainedPLN} PLN",
                      style: TextStyle(color: Colors.white, fontSize: 15,), textAlign: TextAlign.center,),
                    Text("przy obecnym kursie",style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 8))
                  ],
                ),
              )
            ],
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text("Przesuń by sprzedać",
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12,), textAlign: TextAlign.center,),
          ),
          onTap: () {},
        ),
      ),
    );
  }

}


