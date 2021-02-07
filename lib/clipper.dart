import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Rect> {
  Rect rect;

  WaveClipper(this.waveFraction);
  double waveFraction;
  @override
  Rect getClip(Size size) {
    rect = Rect.fromLTWH(0, 0, waveFraction, 2 * size.height);
    return rect;
    
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
