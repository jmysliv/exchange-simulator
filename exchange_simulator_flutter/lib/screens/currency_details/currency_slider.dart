import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchange_simulator_flutter/bloc/currency_details/currency_detail.dart';

class CurrencySlider extends StatefulWidget{
  final Currency currency;
  final double amount;
  CurrencySlider(this.currency, this.amount);

  State<CurrencySlider> createState() => CurrencySliderState();
}

class CurrencySliderState extends State<CurrencySlider>{
  double _value;

  @override
  void initState() {
    super.initState();
    _value = 0.0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.black26,
      child:Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Text("Zainwestuj", style: TextStyle(fontSize: 28, foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.cyanAccent), textAlign: TextAlign.center,),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                value: _value,
                min: 0,
                max: widget.amount,
                label: '${_value.roundToDouble()}',
                onChanged: (value) {
                  setState(
                        () {
                      _value = value;
                    },
                  );
                },
                divisions: (widget.amount.round() > 0) ? widget.amount.floor() : 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Text("Inwesujesz: ${_value.roundToDouble()}PLN", textAlign: TextAlign.center,),
            ),
             Text("Kupujesz: ${(_value*(1/widget.currency.getCurrentExchangeRate())).toStringAsFixed(3)} ${widget.currency.symbol}", textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            buildButton(context),
          ],
        ),
      )
    );
  }

  Widget buildButton(BuildContext context){
    return MaterialButton(
      child: Text('Kup walutę'),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
      highlightColor: Colors.cyan,
      shape: Border.all(width: 2.0, color: Colors.cyan),
      onPressed: (){
        if(_value > 0){
          BlocProvider.of<CurrencyDetailBloc>(context).add(BuyCurrency(widget.currency, _value, widget.amount));
          _value = 0;
        }
      },
    );
  }

}