import 'package:flutter/material.dart';
import '../../../../models/competition_item.dart';
import '../../../../components/curve_painter.dart';
import '../../../../components/empty_data.dart';
import '../../../competition/competition.dart';

class FragmentCompetitionList extends StatefulWidget{

  Map localization;

  FragmentCompetitionList(this.localization);

  @override
  _FragmentCompetitionListState createState() {
    // TODO: implement createState
    return new _FragmentCompetitionListState();
  }

}

class _FragmentCompetitionListState extends State<FragmentCompetitionList>{

  List<CompetitionItem> list = [];
  int page=1;
  bool isLoadPage = true;

  @override
  Widget build(BuildContext context) {
    if(list.length == 0){
      initItems();
    }
    return (isLoadPage)?
      Center(
        child: CircularProgressIndicator(),
      ):
      Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          child: CustomPaint(
            painter: CurvePainter(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment(0, -0.37),
                  width: MediaQuery.of(context).size.width/1.4,
                  child: Text(
                    this.widget.localization['all_competitions'],
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.1,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        (list.length <= 0)?
        EmptyData(this.widget.localization):
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context,i){
              return InkWell(
                child: Card(
                  elevation: 10.0,
                  child: Row(
                    children: <Widget>[
                      (list[i].trophy_icon_url != null && list[i].trophy_icon_url.length > 0)?
                      ImageIcon(NetworkImage(list[i].trophy_icon_url),color: Theme.of(context).primaryColor,size: 100.0):
                      ImageIcon(AssetImage('assets/default_trophy.png'),color: Theme.of(context).primaryColor,size: 100.0),
                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        child: Text(
                          list[i].title,
                          textScaleFactor: 1.3,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return CompetitionPage(list[i],this.widget.localization);
                    })
                  );
                },
              );
            }
          ),
        )
      ],
    );
  }

  initItems(){
    CompetitionItem.getCompetitions(context, 1).then((result){
      if(result.length > 0){
        setState(() {
          page = 1;
          list.clear();
          list.addAll(result);
        });
      }
      setState(() {
        isLoadPage = false;
      });
    });
  }

}