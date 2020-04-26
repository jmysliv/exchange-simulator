import 'package:exchange_simulator_flutter/screens/home/photo_widget.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  static const double minRad = 32.0;
  static const double maxRad = 128.0;
  static const opacityCurve = const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn);
  static const String step1 = "Analizuj jak zmieniają się kursy walut, próbuj przewidzieć które kursy będą rosły, a które spadały."
      " Na tej podstawie wybierz te w które zainwestujesz.";
  static const String step2 = "Po zainwestowaniu obserwuj jak zmieniają się kursy i czekaj. Staraj się wybrać najlepszy moment na sprzedaż, "
      "tak by twoje zyski były jak największe.";
  static const String step3 = "Sprzedawaj, zarabiaj i inwestuj znowu, aż dorobisz się fortuny i awansujesz w naszym rankingu! Jak już stwierdzisz, "
      "że masz odpowiedniego nosa do kursów, przenieś się na prawdziwą giełdę i zarabiaj prawdziwe pieniądze.";

  static Widget _buildPage(BuildContext context, String imageName, String description) {
    return Container(
      color: Color.fromRGBO(10, 10, 10, 0.6),
      child: Center(
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: maxRad * 2.0,
                  height: maxRad * 2.0,
                  child: Hero(
                    createRectTween:(Rect begin, Rect end) {
                      return MaterialRectCenterArcTween(begin: begin, end: end);
                    },
                    tag: imageName,
                    child: OvalPhoto(maxRad, imageName, () {
                      Navigator.of(context).pop();
                    },
                    ),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imagePath, String description, String step) {
    return Column(
      children: <Widget>[
        Container(
          width: minRad * 2.0,
          height: minRad * 2.0,
          child: Hero(
            createRectTween: (Rect begin, Rect end) {
              return MaterialRectCenterArcTween(begin: begin, end: end);
            },
            tag: imagePath,
            child: OvalPhoto(maxRad, imagePath, () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  transitionDuration: Duration(seconds: 1),
                  opaque: false,
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget child) {
                          return Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: _buildPage(context, imagePath, description),
                          );
                        }
                    );
                  },
                ),
              );
            },
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text(step, style: TextStyle(color: Colors.white),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: HomeDrawer(),
      body: ListView(
          children: <Widget>[
            Image.asset("assets/images/logo_transparent.png", height: 250,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Text("Witaj w Currency Exchange Simulator! Interesujesz się giełdą, kursami walut i ekonomią, ale dotychczas bałeś się "
                  "inwestować na giełdzie? Ta aplikacja jest dla Ciebie! Zobacz jak w 3 krokach stać sie giełdowym wyjadaczem!",
                style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              alignment: FractionalOffset.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHero(context, 'assets/images/chart.png', step1, 'Krok 1'),
                  _buildHero(context, 'assets/images/invest.png', step2, 'Krok 2'),
                  _buildHero(context, 'assets/images/money.png', step3, 'Krok 3'),
                ],
              ),
            ),
          ],
        )
    );
  }
}