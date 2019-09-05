import 'package:flutter/material.dart';
import 'fragment/fragment_competition.dart';
import 'fragment/fragment_competitionlist.dart';
import '../../../models/competition_item.dart';

class Body extends StatefulWidget{

  Fragment fragment;
  CompetitionItem competitionItem;

  Body({this.fragment: Fragment.HOME,this.competitionItem});

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

  _BodyState(this.fragment,this.competitionItem);

  @override
  Widget build(BuildContext context) {
    if(this.fragment == Fragment.COMPETITION_LIST){
      homeContenair = FragmentCompetitionList();
    }
    else if(this.fragment == Fragment.COMPETITION && this.competitionItem != null){
      homeContenair = FragmentCompetition(competitionItem);
    }
    else{
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