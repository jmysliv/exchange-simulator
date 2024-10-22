import 'package:exchange_simulator_flutter/bloc/bet/bet.dart';
import 'package:exchange_simulator_flutter/models/bet_filters.dart';
import 'package:exchange_simulator_flutter/models/bet_model.dart';
import 'package:exchange_simulator_flutter/screens/bets/bet_card.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



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
    _filteredBets.sort((Bet a, Bet b) => b.purchaseDate.compareTo(a.purchaseDate));
    _activeFilter = BetFilter.all;
    _activeSorting = BetSorting.date;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  didUpdateWidget(BetsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    applyFilterAndSorting();
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
                  } else if (state is BetFetched){
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
                                return Dismissible(
                                  key: UniqueKey(),
                                  background: Container(
                                      color: Colors.green,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      alignment: AlignmentDirectional.centerStart,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.attach_money,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          Text("SPRZEDAJ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                        ],
                                      )
                                  ),
                                  secondaryBackground: Container(
                                      color: Colors.green,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.attach_money,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          Text("SPRZEDAJ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                        ],
                                      )
                                  ),
                                  onDismissed: (direction){
                                    BlocProvider.of<BetBloc>(context).add(SellBet(_filteredBets[index].id, widget.bets));
                                  },
                                  child: ActiveBetCard(_filteredBets[index]),
                                );
                              } else{
                                return SoldBetCard(_filteredBets[index]);
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
      _filteredBets.sort((Bet a, Bet b) => b.purchaseDate.compareTo(a.purchaseDate));
    } else if(_activeSorting == BetSorting.amount){
      _filteredBets.sort((Bet a, Bet b) => b.amountInvestedPLN.compareTo(a.amountInvestedPLN));
    } else{
      _filteredBets.sort((Bet a, Bet b) => (b.amountObtainedPLN - b.amountInvestedPLN).compareTo((a.amountObtainedPLN - a.amountInvestedPLN)));
    }
  }

}
