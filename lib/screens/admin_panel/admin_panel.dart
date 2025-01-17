import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/competition_item.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/screens/appeal/appeal_page.dart';
import 'package:flutter_cafclcc/screens/matchs_list/matchs_list.dart';
import 'package:flutter_cafclcc/screens/post_signal/post_signal.dart';
import '../../models/drawer_item.dart';
import '../../components/curve_painter.dart';

class AdminPanelPage extends StatefulWidget{

  AdminPanelPage();

  @override
  _AdminPanelPageState createState() {
    return new _AdminPanelPageState();
  }

}

class _AdminPanelPageState extends State<AdminPanelPage>{

  List<DrawerItem> items = [];

  var gridWidth, gridHeight;
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 1.5;
  int _crossAxisCount = 2;

  @override
  void initState() {
    super.initState();
    initItems();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['admin_panel']),
      ),
      body: Column(
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
                      MyLocalizations.instanceLocalization['admin_panel'],
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
                            textScaleFactor: 1.6,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      switch(items[i].id){
                        case 1: //appeal
                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (
                                  builder: (BuildContext context){
                                    return AppealPage();
                                  }
                              ));
                          break;
                        case 2: //post report
                          Navigator.push(
                              context,
                              MaterialPageRoute
                              (
                                  builder: (BuildContext context){
                                    return PostSignalPage();
                                  }
                              )
                          );
                          break;
                        case 3: //other matchs
                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (
                                  builder: (BuildContext context){
                                    return MatchsList(null, TypeList.OTHER,
                                      idCompetitionType: CompetitionItem.COMPETITION_TYPE);
                                  }
                              )
                          );
                          break;
                      }
                    },
                  );
                }
            ),
          )
        ],
      ),
    );
  }

  initItems(){
    DrawerItem appeal = new DrawerItem(1, MyLocalizations.instanceLocalization['subscriber_appeal'], DrawerType.item,iconPath: 'assets/icons/login.png');
    DrawerItem post_report = new DrawerItem(2, MyLocalizations.instanceLocalization['post_report'], DrawerType.item,iconPath: 'assets/icons/login.png');
    DrawerItem other_matchs = new DrawerItem(3, MyLocalizations.instanceLocalization['other_matchs'], DrawerType.item,iconPath: 'assets/icons/login.png');

    items.add(appeal);
    items.add(post_report);
    items.add(other_matchs);
  }

}