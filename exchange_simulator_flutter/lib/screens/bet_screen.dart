import 'package:exchange_simulator_flutter/bloc/bet/bet.dart';
import 'package:exchange_simulator_flutter/models/bet_filters.dart';
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
  BetFilter _activeFilter;
  BetSorting _activeSorting;


  @override
  void initState() {
    super.initState();
    _filteredBets = widget.bets;
    _filteredBets.sort((Bet a, Bet b) => a.purchaseDate.compareTo(b.purchaseDate));
    _activeFilter = BetFilter.all;
    _activeSorting = BetSorting.date;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: appBarWithFilters(context),
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

  Widget appBarWithFilters(BuildContext context){
    final activeStyle = Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).accentColor);
    final defaultStyle = Theme.of(context).textTheme.body1;
    return  AppBar(
        title: Text('Moje Inwestycje'),
        actions: [
          PopupMenuButton<BetFilter>(
            onSelected: (filter) {
              setState(() {
                _activeFilter = filter;
                applyFilterAndSorting();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<BetFilter>>[
              PopupMenuItem<BetFilter>(
                value: BetFilter.all,
                child: Text("Pokaż wszystkie", style: _activeFilter == BetFilter.all ? activeStyle : defaultStyle),
              ),
              PopupMenuItem<BetFilter>(
                value: BetFilter.active,
                child: Text("Pokaż aktywne", style: _activeFilter == BetFilter.active ? activeStyle : defaultStyle),
              ),
              PopupMenuItem<BetFilter>(
                value: BetFilter.past,
                child: Text("Pokaż zakończone", style: _activeFilter == BetFilter.past ? activeStyle : defaultStyle),
              ),
            ],
            icon: Icon(Icons.filter_list),
          ),
          PopupMenuButton<BetSorting>(
            onSelected: (sorting){
              setState(() {
                _activeSorting = sorting;
                applyFilterAndSorting();
              });

            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<BetSorting>>[
              PopupMenuItem<BetSorting>(
                value: BetSorting.date,
                child: Text("Sortuj po dacie zakupu", style: _activeSorting == BetSorting.date ? activeStyle : defaultStyle),
              ),
              PopupMenuItem<BetSorting>(
                value: BetSorting.profit,
                child: Text("Sortuj po zysku", style: _activeSorting == BetSorting.profit ? activeStyle : defaultStyle),
              ),
              PopupMenuItem<BetSorting>(
                value: BetSorting.amount,
                child: Text("Sortuj po zainwestowanej kwocie", style: _activeSorting == BetSorting.amount ? activeStyle : defaultStyle),
              ),
            ],
          ),
        ]
    );
  }

  List<Bet> applyFilterAndSorting(){
    _filteredBets = widget.bets;
    if(_activeFilter == BetFilter.active){
      _filteredBets = _filteredBets.where( (bet) => bet.soldDate == null).toList();
    } else if(_activeFilter == BetFilter.past){
      _filteredBets = _filteredBets.where( (bet) => bet.soldDate != null).toList();
    }

    if(_activeSorting == BetSorting.date){
      _filteredBets.sort((Bet a, Bet b) => a.purchaseDate.compareTo(b.purchaseDate));
    } else if(_activeSorting == BetSorting.amount){
      _filteredBets.sort((Bet a, Bet b) => b.amountInvestedPLN.compareTo(a.amountInvestedPLN));
    } else{
      _filteredBets.sort((Bet a, Bet b) => (b.amountObtainedPLN - b.amountInvestedPLN).compareTo((a.amountObtainedPLN - a.amountInvestedPLN)));
    }
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
              style: TextStyle(color: ((bet.amountObtainedPLN - bet.amountInvestedPLN) > 0) ? Colors.green : Colors.red,
                fontStyle: FontStyle.italic, fontSize: 10,), textAlign: TextAlign.center,)
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


