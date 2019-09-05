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
      child: Text(this.widget.competitionItem.name),
    );
  }

}