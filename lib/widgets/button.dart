import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:provider/provider.dart';

import '../model.dart';

class PlayerButton extends StatelessWidget {
  double radius;
  Icon iconPrimary;
  Icon iconAlternate;
  bool isInnerColorFill;
  int musicNo ;
  PlayerButton(
      {this.iconAlternate,
      this.iconPrimary,
      this.radius,
      this.isInnerColorFill = false,
      this.musicNo=0});
  Color iconColor = Color(0xFF76b54a4);
  List<Color> gradientColors = [Color(0xFFe5ecf5), Color(0xFFc1c7ce)];
  double angle = -105 * Math.pi / 180;

  @override
  Widget build(BuildContext context) {
    PlayerModel model = Provider.of<PlayerModel>(context);
    bool musicIsPlaying = model.musicList[musicNo].isplayer;
    double x = Math.cos(angle);
    double y = Math.sin(angle);
    return Container(
      alignment: Alignment.center,
      width: 2 * radius + 10,
      height: 2 * radius + 10,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
            color: !isInnerColorFill ? Colors.grey : Color(0xFFaeb4ba),
            width: 1)),
        color: iconColor,
        shape: BoxShape.circle,
        gradient: !isInnerColorFill
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                    0.33,
                    0.66,
                    1
                  ],
                colors: [
                    Color(0xFFaeb4ba),
                    Color(0xFFD6dde5),
                    Color(0xFFfefefe)
                  ])
            : null,
      ),
      child: Container(
        child: !musicIsPlaying ? iconPrimary : iconAlternate,
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment(x, y),
              end: Alignment(-x, -y),
              colors: musicIsPlaying
                  ? gradientColors.reversed.toList()
                  : gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(-5 * x, -5 * y),
                  color: Color(0xFFb6bcc3)),
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(5 * x, 5 * y),
                  color: Color(0xFFf6feff))
            ]),
      ),
    );
  }
}
