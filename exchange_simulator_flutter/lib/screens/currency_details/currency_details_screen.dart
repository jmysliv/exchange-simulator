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
        CurrencyDetailBloc(_betRepository, _currencyRepository)..add(InitCurrencyDetail(id)),
        child: BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
            builder: (buildContext, state) {
              if (state is CurrencyDetailInitial)
                return Container();
              else if (state is CurrencyDetailError)
                return ErrorScreen(state.message);
              else {
                Currency currency;
                if(state is CurrencyBought) currency = state.currency;
                if(state is NotEnoughMoney) currency = state.currency;
                if(state is CurrencyDetailFetched) currency = state.currency;
                if(state is CurrencyDetailLoading) currency = state.currency;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("${currency.name}"),
                  ),
                  body: Container(
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
                        CurrencySlider(currency),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                );
              }
            }
        )
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

