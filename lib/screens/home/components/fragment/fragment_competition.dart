import 'package:flutter/material.dart';
import '../../../../models/competition_item.dart';

class FragmentCompetition extends StatefulWidget{

  CompetitionItem competitionItem;

  FragmentCompetition(this.competitionItem);

  @override
  _FragmentCompetitionState createState() {
    // TODO: implement createState
    return new _FragmentCompetitionState();
  }

}

class _FragmentCompetitionState extends State<FragmentCompetition>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: CurvePainter(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImageIcon(AssetImage('assets/default_trophy.png'),color: Colors.white,size: 100.0),
                  Container(
                    alignment: Alignment(0, -0.37),
                    width: MediaQuery.of(context).size.width/1.4,
                    child: Text(
                      this.widget.competitionItem.title,
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.1,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class CurvePainter extends CustomPainter {

  BuildContext context;

  CurvePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();
    double height = 0.5;
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