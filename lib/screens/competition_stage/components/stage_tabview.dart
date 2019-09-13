import 'package:flutter/material.dart';
import '../../../models/competition_stage.dart';

class StageTabview extends StatefulWidget{

  CompetitionStage competitionStage;
  int selectedButton;
  int selectedGroup;

  Map localization;

  StageTabview(this.localization,this.competitionStage,this.selectedGroup,this.selectedButton);

  @override
  _StageTabviewState createState() {
    // TODO: implement createState
    return new _StageTabviewState(this.competitionStage,this.selectedGroup,this.selectedButton);
  }

}

class _StageTabviewState extends State<StageTabview>{

  CompetitionStage competitionStage;
  int selectedButton;
  int selectedGroup;

  _StageTabviewState(this.competitionStage,this.selectedGroup,this.selectedButton);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              (competitionStage.groups != null && competitionStage.groups.length > 0)?
              new Container(
                height: 60.0,
                color: Colors.black,
                padding: EdgeInsets.all(5.0),
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: competitionStage.groups.length,
                  itemBuilder: (context,index){
                    return Container(
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            selectedGroup = competitionStage.groups[index].id;
                          });
                        },
                        color: (selectedGroup == competitionStage.groups[index].id)? Colors.white : Theme.of(context).primaryColor,
                        elevation: 10.0,
                        textColor: (selectedGroup == competitionStage.groups[index].id)? Theme.of(context).primaryColor : Colors.white,
                        child: Text(competitionStage.groups[index].title),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      padding: EdgeInsets.all(2.0),
                    );
                  },
                ),
              ) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.05,
                    child: RaisedButton(
                      child: Text(
                        this.widget.localization['last_results'],
                        style: TextStyle(
                          color: (selectedButton == 1)? Theme.of(context).primaryColor : Colors.white,
                        ),
                      ),
                      color: (selectedButton == 1)? Colors.white : Theme.of(context).primaryColor,
                      onPressed: (){
                        setState(() {
                          selectedButton = 1;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.05,
                    child: RaisedButton(
                      child: Text(
                        this.widget.localization['schedule'],
                        style: TextStyle(
                          color: (selectedButton == 2)? Theme.of(context).primaryColor : Colors.white,
                        ),
                      ),
                      color: (selectedButton == 2)? Colors.white : Theme.of(context).primaryColor,
                      onPressed: (){
                        setState(() {
                          selectedButton = 2;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2.05*2,
                child: RaisedButton(
                  child: Text(
                    this.widget.localization['table'],
                    style: TextStyle(
                      color: (selectedButton == 3)? Theme.of(context).primaryColor : Colors.white,
                    ),
                  ),
                  color: (selectedButton == 3)? Colors.white : Theme.of(context).primaryColor,
                  onPressed: (){
                    setState(() {
                      selectedButton = 3;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}