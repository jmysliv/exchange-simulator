import 'package:exchange_simulator_flutter/bloc/currency/currency.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrenciesScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;

  CurrenciesScreen() :
    _currencyRepository = CurrencyRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {

    return BlocProvider<CurrencyBloc>(
        create: (context) => CurrencyBloc(_currencyRepository)..add(InitCurrency()),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (buildContext, state) {
            if(state is CurrencyInitial) return LoadingScreen("Ładowanie pieniędzy na serwer...");
            else if(state is CurrencyError) return ErrorScreen(state.message);
            else if(state is CurrencyLoading){
              return currenciesList(buildContext, state.oldCurrencies);
            } else{
              return currenciesList(buildContext, (state as CurrencyFetched).currencies);
            }
          }
        )
    );
  }

  Widget currenciesList(BuildContext context, List<Currency> currencies){
    return Scaffold(
      appBar: AppBar(
        title: Text("Waluty"),
      ),
      drawer: HomeDrawer(),
      body: RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<CurrencyBloc>(context).add(FetchCurrency(currencies));
            return Future.delayed(Duration(seconds: 0));
          },
          child: BlocListener<CurrencyBloc, CurrencyState>(
              listener: (context, state) {
                if(state is CurrencyLoading) {
                  Scaffold.of(context)..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Ładowanie', style: TextStyle(color: Colors.white),),
                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent))],
                          ),
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 2),
                        ));
                } else{
                  Scaffold.of(context)..removeCurrentSnackBar();
                }
              },
              child: Container(
                child: Center(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: (currencies == null) ? 0 : currencies.length,
                      itemBuilder: (context, index) {
                        return currencyCard(context, currencies[index]);
                      })
                )
              )
          )
      )
    );
  }

  Widget currencyCard(BuildContext context, Currency currency){
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          leading: Container(
              padding: EdgeInsets.only(right: 5.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.attach_money)
          ),
          title: Text(
            currency.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          subtitle: Text(currency.symbol,  style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ),
    );
  }
}