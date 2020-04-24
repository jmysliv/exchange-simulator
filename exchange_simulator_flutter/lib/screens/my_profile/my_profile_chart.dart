import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:exchange_simulator_flutter/models/account_balance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class MyProfileChart extends StatelessWidget{
  final AccountBalance balance;
  static BalanceTimestamp timestampPointer;

  MyProfileChart(this.balance);

  @override
  Widget build(BuildContext context){
    return TimeSeriesChart(
      [
        Series<BalanceTimestamp, DateTime>(
          id: 'Account balance',
          colorFn: (_, __) => ColorUtil.fromDartColor(Colors.cyan),
          domainFn: (BalanceTimestamp timestamp, _) => timestamp.date,
          measureFn: (BalanceTimestamp timestamp, _) => timestamp.amountOfPLN,
          data: balance.balanceTimestamps,
        ),
      ],
      animate: true,
      animationDuration: Duration(seconds: 1),
      behaviors: [
        LinePointHighlighter(
            symbolRenderer: RenderTimestampInfo()
        ),
        ChartTitle('Zmiana stanu konta w czasie',
            titleStyleSpec: TextStyleSpec(color: Color.fromHex( code: "#ffffff")),
            behaviorPosition: BehaviorPosition.top,
            titleOutsideJustification: OutsideJustification.middle,
            innerPadding: 40,
            outerPadding: 30
        ),
      ],
      primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 5),
          tickFormatterSpec: BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat.currency(locale: 'PL'))),
      domainAxis: DateTimeAxisSpec(
          tickProviderSpec: AutoDateTimeTickProviderSpec(includeTime: false,)),
      selectionModels: [
        SelectionModelConfig(
            changedListener: (SelectionModel model) {
              if(model.hasDatumSelection){
                MyProfileChart.timestampPointer = model.selectedDatum.first.datum as BalanceTimestamp;
              }
            }
        )
      ],
      dateTimeFactory: const LocalDateTimeFactory(),

    );
  }

}

class RenderTimestampInfo extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, FillPatternType fillPattern, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx, fillPattern: fillPattern);
    canvas.drawRect(
        Rectangle(bounds.left - 45, bounds.top - 35, bounds.width + 80, bounds.height + 20),
        fill: Color.fromHex( code: "#1f1f1f")
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 8;
    canvas.drawText(
        TextElement.TextElement("Kwota: ", style: textStyle),
        (bounds.left - 30).round(),
        (bounds.top - 30).round()
    );
    canvas.drawText(
        TextElement.TextElement("${MyProfileChart.timestampPointer.amountOfPLN.toStringAsFixed(3)}", style: textStyle),
        (bounds.left - 5).round(),
        (bounds.top - 30).round()
    );
    canvas.drawText(
        TextElement.TextElement("Data: ", style: textStyle),
        (bounds.left - 30).round(),
        (bounds.top - 20).round()
    );
    canvas.drawText(
        TextElement.TextElement("${DateFormat.yMd().format(MyProfileChart.timestampPointer.date)}", style: textStyle),
        (bounds.left - 5).round(),
        (bounds.top - 20).round()
    );
  }
}