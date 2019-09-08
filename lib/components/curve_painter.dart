import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {

  BuildContext context;

  CurvePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();
    double height = 0.625;
    path.moveTo(0, size.height*height);
    path.quadraticBezierTo(size.width*0.125, size.height, size.width*0.25, size.height*height);
    path.quadraticBezierTo(size.width*0.375, size.height, size.width*0.5, size.height*height);
    path.quadraticBezierTo(size.width*0.625, size.height, size.width*0.75, size.height*height);
    path.quadraticBezierTo(size.width*0.875, size.height, size.width, size.height*height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}