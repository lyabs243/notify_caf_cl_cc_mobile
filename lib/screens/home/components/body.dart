import 'package:flutter/material.dart';
import 'fragment/fragment_competitionlist.dart';
import '../../../models/competition_item.dart';
import '../../../models/home_infos.dart';
import '../../../models/user.dart';

class Body extends StatefulWidget{

  Fragment fragment;
  CompetitionItem competitionItem;
  Map localization;

  Body(this.localization,{this.fragment: Fragment.HOME,this.competitionItem});

  @override
  _BodyState createState() {
    // TODO: implement createState
    return new _BodyState(fragment,competitionItem);
  }

}

class _BodyState extends State<Body>{

  Widget homeContenair;
  Fragment fragment;
  CompetitionItem competitionItem;
  HomeInfos homeInfos;

  _BodyState(this.fragment,this.competitionItem);

  @override
  Widget build(BuildContext context) {
    if(this.fragment == Fragment.COMPETITION_LIST){
      homeContenair = FragmentCompetitionList(this.widget.localization);
    }
    else{
      homeInfos = new HomeInfos();
      User.getInstance().then((user){
        homeInfos.initData(context, user.id);
      });
      homeContenair = Center(
      );
    }
    return homeContenair;
  }
}

enum Fragment{
  HOME,
  COMPETITION,
  COMPETITION_LIST
}