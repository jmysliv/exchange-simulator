import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CurrencyChart extends StatelessWidget{
  final Currency currency;
  static Timestamp timestampPointer;

  CurrencyChart(this.currency);

  @override
  Widget build(BuildContext context){
    return TimeSeriesChart(
      [
        Series<Timestamp, DateTime>(
          id: 'Exchange rate',
          colorFn: (_, __) => ColorUtil.fromDartColor(Colors.cyan),
          domainFn: (Timestamp timestamp, _) => timestamp.date,
          measureFn: (Timestamp timestamp, _) => timestamp.exchangeRate,
          data: currency.timestamps,
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