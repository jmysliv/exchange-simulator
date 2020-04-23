import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';


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
                return CurrencyChart(currency);
              }
            }
        )
    );
  }
}

class CurrencyChart extends StatefulWidget{
  final Currency currency;

  CurrencyChart(this.currency);

  State<CurrencyChart> createState() => _CurrencyChartState();
}

class _CurrencyChartState extends State<CurrencyChart>{
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currency.name}"),
      ),
      body: Container(
        child: charts.TimeSeriesChart(
          [
            charts.Series<Timestamp, DateTime>(
              id: 'Exchange rate',
              colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.cyan),
              domainFn: (Timestamp timestamp, _) => timestamp.date,
              measureFn: (Timestamp timestamp, _) => timestamp.exchangeRate,
              data: widget.currency.timestamps,
            ),
          ],
          animate: true,
          animationDuration: Duration(seconds: 1),
          behaviors: [
            new charts.SlidingViewport(),
          ],
          primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 5, dataIsInWholeNumbers: false),
              tickFormatterSpec: charts.BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat.currency(locale: 'PL'))),
          domainAxis: new charts.DateTimeAxisSpec(
              tickProviderSpec: charts.DayTickProviderSpec(increments: [80])),
//          selectionModels: [
//            charts.SelectionModelConfig(
//              type: charts.SelectionModelType.info,
//              changedListener:(context){},
//            )
//          ],
          dateTimeFactory: const charts.LocalDateTimeFactory(),

        ),
      ),
    );
  }



}