import 'package:flutter/material.dart';
import '../../../../models/competition_item.dart';
import '../../../../models/drawer_item.dart';

class FragmentCompetition extends StatefulWidget{

  CompetitionItem competitionItem;
  Map localization;

  FragmentCompetition(this.competitionItem,this.localization);

  @override
  _FragmentCompetitionState createState() {
    // TODO: implement createState
    return new _FragmentCompetitionState();
  }

}

class _FragmentCompetitionState extends State<FragmentCompetition>{

  String url_icon;
  List<DrawerItem> items = [];

  var gridWidth, gridHeight;
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 1.5;
  int _crossAxisCount = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initItems();
    url_icon = this.widget.competitionItem.trophy_icon_url;
  }

  @override
  Widget build(BuildContext context) {
    gridWidth = (MediaQuery.of(context).size.width - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    gridHeight = gridWidth / _aspectRatio;
    if(!(url_icon != null && url_icon.length > 0)) {
      this.widget.competitionItem.getCompetition(context).then((success) {
        if (success) {
          setState(() {
            url_icon = this.widget.competitionItem.trophy_icon_url;
          });
        }
      });
    }
    return Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: CurvePainter(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (url_icon != null && url_icon.length > 0)?
                  ImageIcon(NetworkImage(url_icon),color: Colors.white,size: 100.0):
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
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  crossAxisSpacing: _crossAxisSpacing,
                  mainAxisSpacing: _mainAxisSpacing,
                  childAspectRatio: _aspectRatio,
                ),
                itemCount: items.length,
                itemBuilder: (context,i){
                  return InkWell(
                    child: Card(
                      elevation: 10.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage(
                              items[i].iconPath
                            ),
                            color: Theme.of(context).primaryColor,
                            size: 50.0,
                          ),
                          Text(
                            items[i].title,
                            textScaleFactor: 1.8,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){

                    },
                  );
                }
            ),
          )
        ],
      );
  }

  initItems(){

    DrawerItem live = new DrawerItem(1, this.widget.localization['live'], DrawerType.item,iconPath: 'assets/icons/login.png');
    DrawerItem last_results = new DrawerItem(2, this.widget.localization['last_results'], DrawerType.item,iconPath: 'assets/icons/profile.png');
    DrawerItem schedule = new DrawerItem(3, this.widget.localization['schedule'], DrawerType.item,iconPath: 'assets/icons/logout.png',visible: false);
    DrawerItem stages = new DrawerItem(4, this.widget.localization['stages'], DrawerType.item,iconPath: 'assets/icons/login.png');
    DrawerItem scorers = new DrawerItem(5, this.widget.localization['scorers'], DrawerType.item,iconPath: 'assets/icons/logout.png');

    items.add(live);
    items.add(last_results);
    items.add(schedule);
    items.add(stages);
    items.add(scorers);
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