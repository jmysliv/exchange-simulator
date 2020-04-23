import 'dart:math';
import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
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
  static Timestamp timestampPointer;

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
        child: ListView(
          children: <Widget>[
            displayChart(context)
          ],
        )
      ),
    );
  }


  Widget displayChart(BuildContext context){
    return  TimeSeriesChart(
      [
        Series<Timestamp, DateTime>(
          id: 'Exchange rate',
          colorFn: (_, __) => ColorUtil.fromDartColor(Colors.cyan),
          domainFn: (Timestamp timestamp, _) => timestamp.date,
          measureFn: (Timestamp timestamp, _) => timestamp.exchangeRate,
          data: widget.currency.timestamps,
        ),
      ],
      animate: true,
      animationDuration: Duration(seconds: 1),
      behaviors: [
        LinePointHighlighter(
            symbolRenderer: RenderTimestampInfo()
        )
      ],
      primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 5, dataIsInWholeNumbers: false),
          tickFormatterSpec: BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat.currency(locale: 'PL'))),
      domainAxis: DateTimeAxisSpec(
          tickProviderSpec: DayTickProviderSpec(increments: [80])),
      selectionModels: [
        SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if(model.hasDatumSelection){
              CurrencyChart.timestampPointer = model.selectedDatum.first.datum as Timestamp;
            }
          }
        )
      ],
      dateTimeFactory: const LocalDateTimeFactory(),

    );
  }

  Widget displayCurrencyInfo(BuildContext context){
    return 
  }

}

class RenderTimestampInfo extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, FillPatternType fillPattern, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx, fillPattern: fillPattern);
    canvas.drawRect(
        Rectangle(bounds.left - 45, bounds.top - 50, bounds.width + 80, bounds.height + 20),
        fill: Color.fromHex( code: "#1f1f1f")
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 8;
    canvas.drawText(
        TextElement.TextElement("Kurs: ", style: textStyle),
        (bounds.left - 30).round(),
        (bounds.top - 46).round()
    );
    canvas.drawText(
        TextElement.TextElement("${CurrencyChart.timestampPointer.exchangeRate.toStringAsFixed(3)}", style: textStyle),
        (bounds.left - 5).round(),
        (bounds.top - 46).round()
    );
    canvas.drawText(
        TextElement.TextElement("Data: ", style: textStyle),
        (bounds.left - 30).round(),
        (bounds.top - 36).round()
    );
    canvas.drawText(
        TextElement.TextElement("${DateFormat.yMd().format(CurrencyChart.timestampPointer.date)}", style: textStyle),
        (bounds.left - 5).round(),
        (bounds.top - 36).round()
    );
  }
}