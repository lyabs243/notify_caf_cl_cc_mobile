import 'package:flutter/material.dart';

class MatchCompetitionPainter extends CustomPainter {

  BuildContext context;

  MatchCompetitionPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width*80/100, size.height);
    path.quadraticBezierTo(size.width * 85/100, 0, size.width, 0);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}