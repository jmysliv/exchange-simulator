import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  final String message;
  ErrorScreen(this.message);

  @override
  State<ErrorScreen> createState() => ErrorScreenState(message);
}

class ErrorScreenState extends State<ErrorScreen> with TickerProviderStateMixin {
  final String message;
  ErrorScreenState(this.message);

  AnimationController _tearController;
  Animation<double> _animatedTear;



  @override
  void initState() {
    _tearController = AnimationController(vsync: this, duration:  Duration(milliseconds: 3000), );
    _animatedTear = Tween<double>(begin: 0, end: 100).animate(_tearController)..addListener(() => setState(() {}));
    _tearController.forward();
    _tearController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset("assets/images/jordan.png", scale: 2,),
                Positioned(
                    top: _animatedTear.value,
                    right: 0,
                    left: 20,
                    child: Image.asset("assets/images/tear.png", scale: 10,)
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                )
              ],
            ),
          ],
        )
      )

    );
  }

  @override
  void dispose() {
    _tearController.dispose();
    super.dispose();
  }
}