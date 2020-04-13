import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  final String message;
  LoadingScreen(this.message);

  @override
  State<LoadingScreen> createState() => LoadingScreenState(message);
}

class LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  final String message;
  LoadingScreenState(this.message);

  AnimationController _coinController;
  Animation<double> _animatedCoin;
  Animation<double> _opacity;

  AnimationController _coinController1;
  Animation<double> _animatedCoin1;
  Animation<double> _opacity1;

  AnimationController _coinController2;
  Animation<double> _animatedCoin2;
  Animation<double> _opacity2;

  AnimationController _coinController3;
  Animation<double> _animatedCoin3;
  Animation<double> _opacity3;

  AnimationController _dollarController;
  Animation<double> _animatedDollar;
  Animation<double> _opacity4;



  @override
  void initState() {
    _coinController = AnimationController(vsync: this, duration:  Duration(milliseconds: 1500), );
    _animatedCoin = Tween<double>(begin: -150, end: 300).animate(_coinController)..addListener(() => setState(() {}));
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_coinController)..addListener(() => setState(() {}));
    _coinController.forward();
    _coinController.repeat();

    _coinController1 = AnimationController(vsync: this, duration:  Duration(milliseconds: 2000), );
    _animatedCoin1 = Tween<double>(begin: -50, end: 300).animate(_coinController1)..addListener(() => setState(() {}));
    _opacity1 = Tween<double>(begin: 1.0, end: 0.0).animate(_coinController1)..addListener(() => setState(() {}));
    _coinController1.forward();
    _coinController1.repeat();

    _coinController2 = AnimationController(vsync: this, duration:  Duration(milliseconds: 2300), );
    _animatedCoin2 = Tween<double>(begin: -100, end: 300).animate(_coinController2)..addListener(() => setState(() {}));
    _opacity2 = Tween<double>(begin: 1.0, end: 0.0).animate(_coinController2)..addListener(() => setState(() {}));
    _coinController2.forward();
    _coinController2.repeat();

    _coinController3 = AnimationController(vsync: this, duration:  Duration(milliseconds: 1700), );
    _animatedCoin3 = Tween<double>(begin: -150, end: 300).animate(_coinController3)..addListener(() => setState(() {}));
    _opacity3 = Tween<double>(begin: 1.0, end: 0.0).animate(_coinController3)..addListener(() => setState(() {}));
    _coinController3.forward();
    _coinController3.repeat();

    _dollarController = AnimationController(vsync: this, duration:  Duration(milliseconds: 2500), );
    _animatedDollar = Tween<double>(begin: -200, end: 300).animate(_dollarController)..addListener(() => setState(() {}));
    _opacity4 = Tween<double>(begin: 1.0, end: 0.0).animate(_dollarController)..addListener(() => setState(() {}));
    _dollarController.forward();
    _dollarController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(height: 400,),
                    Positioned(
                        top: _animatedCoin.value,
                        right: 100,
                        left: 0,
                        child: Opacity(
                            opacity: _opacity.value,
                            child: Image.asset("assets/images/coin.png", scale: 10,)
                        )
                    ),
                    Positioned(
                        top: _animatedCoin1.value,
                        right: 200,
                        left: 0,
                        child: Opacity(
                            opacity: _opacity1.value,
                            child: Image.asset("assets/images/coin2.png", scale: 30,)
                        )
                    ),
                    Positioned(
                        top: _animatedCoin2.value,
                        right: 0,
                        left: 100,
                        child: Opacity(
                            opacity: _opacity2.value,
                            child: Image.asset("assets/images/coin2.png", scale: 30,)
                        )
                    ),
                    Positioned(
                        top: _animatedCoin3.value,
                        right: 0,
                        left: 200,
                        child: Opacity(
                            opacity: _opacity3.value,
                            child: Image.asset("assets/images/coin.png", scale: 10,)
                        )
                    ),
                    Positioned(
                        top: _animatedDollar.value,
                        right: 0,
                        left: 0,
                        child: Opacity(
                            opacity: _opacity4.value,
                            child: Image.asset("assets/images/dollar.png", scale: 30,)
                        )
                    )
                  ],
                ),
                Text(message, style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,)
              ],
            )
        )
      )
    );
  }

  @override
  void dispose() {
    _coinController.dispose();
    _coinController1.dispose();
    _coinController2.dispose();
    _coinController3.dispose();
    _dollarController.dispose();
    super.dispose();
  }
}