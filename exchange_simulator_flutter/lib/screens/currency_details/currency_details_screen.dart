import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/currency_details/currency_chart.dart';
import 'package:exchange_simulator_flutter/screens/currency_details/currency_slider.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyDetailScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;
  final BetRepository _betRepository;
  final String id;

  CurrencyDetailScreen(this.id) :
        _currencyRepository = CurrencyRepository(UserRepository.getInstance()),
        _betRepository = BetRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyDetailBloc>(
        create: (context) =>
        CurrencyDetailBloc(_betRepository, _currencyRepository, UserRepository.getInstance())..add(InitCurrencyDetail(id)),
        child: BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
            builder: (buildContext, state) {
              if (state is CurrencyDetailInitial)
                return Container();
              else if (state is CurrencyDetailError)
                return ErrorScreen(state.message);
              else {
                Currency currency;
                double amount;
                if(state is CurrencyBought) {
                  currency = state.currency;
                  amount = state.amountOfPLN;
                }
                if(state is CurrencyDetailFetched){
                  currency = state.currency;
                  amount = state.amountOfPLN;
                }
                if(state is CurrencyDetailLoading){
                  currency = state.currency;
                  amount = state.amountOfPLN;
                }
                return buildScaffold(buildContext, currency, amount);
              }
            }
        )
    );
  }

  Widget buildScaffold(BuildContext context, Currency currency, double amount){
    return Scaffold(
      appBar: AppBar(
        title: Text("${currency.name}"),
      ),
      body: Container(
          child: RefreshIndicator(
            onRefresh: (){
              BlocProvider.of<CurrencyDetailBloc>(context).add(RefreshCurrencyDetail(currency, amount));
              return Future.delayed(Duration(seconds: 0));
            },
            child: BlocListener<CurrencyDetailBloc, CurrencyDetailState>(
              listener: (context, state){
                if (state is CurrencyDetailLoading){
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
                } else if(state is CurrencyBought){
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Zainwestowano', style: TextStyle(color: Colors.white)),
                              Icon(Icons.check_circle, color: Colors.white,)
                            ],
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ));
                } else{
                  Scaffold.of(context).hideCurrentSnackBar();
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                      color: Colors.black12,
                      height: 450,
                      child: CurrencyChart(currency)
                  ),
                  SizedBox(height: 15,),
                  _buildItem("Oznaczenie:", "${currency.symbol}", Icons.monetization_on),
                  SizedBox(height: 15,),
                  _buildItem("Aktualny kurs:", "${currency.getCurrentExchangeRate().toStringAsFixed(3)}", Icons.equalizer),
                  SizedBox(height: 15,),
                  CurrencySlider(currency, amount),
                  SizedBox(height: 30,)
                ],
              ),
            )
          )
      ),
    );
  }

  Widget _buildItem(String label, String count, IconData icon) {
    TextStyle _statStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    );
    return  Container(
        decoration: BoxDecoration(
          color: Colors.black12,),
      child:Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListTile(
          leading: Text(
            label,
            style: _statStyle,
          ),
          title: Row(
            children: <Widget>[
              Icon(icon),
              SizedBox(width: 10,),
              Text(
                count,
                style: _statStyle,
              ),
            ],
          ),
        ),
      )
    );
  }
}

