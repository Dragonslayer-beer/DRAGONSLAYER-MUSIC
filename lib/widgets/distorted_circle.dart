import 'dart:math';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/painting.dart';

import '../model.dart';

class DistortedCircle extends StatefulWidget {
  DistortedCircle({this.child});
  final Widget child;

  @override
  _DistortedCircleState createState() => _DistortedCircleState();
}

class _DistortedCircleState extends State<DistortedCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _distortAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 30))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _controller.repeat();
          });
    ;
    _distortAnim = Tween<double>(begin: pi / 2, end: 2 * pi).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: _controller));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    PlayerModel model = Provider.of<PlayerModel>(context);
    if (model.musicList[model.currentTrack].isplayer &&
        _controller.status != AnimationStatus.completed)
      _controller.forward();
    else
      _controller.stop();
    Widget child = widget.child;
    return Transform.rotate(
        angle: _distortAnim.value,
        child: CustomPaint(
          child: CustomPaint(
            child: Transform.rotate(
              angle: _distortAnim.value,
              child: child,
            ),
          ),
          painter: DistortPainter(),
        ));
  }
}

class DistortPainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Colors.black54
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 3);
  double one = 10 * pi / 180;
  double two = 20 * pi / 180;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1, -1);
    for (int i = 0; i < 36; i++)
      paintZigZag(
          canvas,
          _paint,
          Offset(cos(i * one) * 180, sin(i * one) * 180),
          Offset(cos(i * two) * 180, sin(i * two) * 180),
          Random().nextInt(50) + 1,
          15);
  }

  @override
  bool shouldRepaint(DistortPainter oldDelegate) => false;
}
