import 'package:flutter/material.dart';

class ArrowAnimation extends StatefulWidget{
  ArrowAnimation();

  @override
  State<ArrowAnimation> createState() => ArrowAnimationState();
}

class ArrowAnimationState extends State<ArrowAnimation> with TickerProviderStateMixin {
  AnimationController _arrowController;
  Animation<double> _animatedArrow;
  Animation<double> _opacity;



  @override
  void initState() {
    _arrowController = AnimationController(vsync: this, duration:  Duration(milliseconds: 3000), );
    _animatedArrow = Tween<double>(begin: -0.3, end: 0.8).animate(_arrowController)..addListener(() => setState(() {}));
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _arrowController, curve: Curves.easeInExpo))..addListener(() => setState(() {}));
    _arrowController.forward();
    _arrowController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(height: 50, width: MediaQuery.of(context).size.width/6),
        Positioned(
            left: _animatedArrow.value * MediaQuery.of(context).size.width/6,
            top: 10,
            child: Opacity(
                opacity: _opacity.value,
                child: Icon(Icons.arrow_forward, color: Colors.cyanAccent,)
            )
        ),

       ]
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }
}