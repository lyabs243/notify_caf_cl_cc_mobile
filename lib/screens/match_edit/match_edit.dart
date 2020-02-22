import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/lang_code.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/match_item.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import '../../models/constants.dart' as constants;

class MatchEdit extends StatefulWidget {

  MatchItem matchItem;

  MatchEdit(this.matchItem);

  @override
  State<StatefulWidget> createState() {
    return _MatchEditState(this.matchItem);
  }

}

class _MatchEditState extends State<MatchEdit> {

  MatchItem matchItem;
  TextEditingController _controller_team_a_goal, _controller_team_b_goal, _controller_team_a_penalty,
      _controller_team_b_penalty;

  List _statusTitles = [MyLocalizations.instanceLocalization['not_started'], MyLocalizations.instanceLocalization['in_progress'],
  MyLocalizations.instanceLocalization['half_time'], MyLocalizations.instanceLocalization['full_time'],
  MyLocalizations.instanceLocalization['extra_time'], MyLocalizations.instanceLocalization['penalty_kick'],
  MyLocalizations.instanceLocalization['postponed'], MyLocalizations.instanceLocalization['to_define_manually']];
  List _statusValues = ["0", "1", "2", "3", "4", "5", "6", "7"];
  int matchDateTimestamp;
  DateTime _matchDate;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentStatus;
  bool _isLoading = false, apiUpdate;

  int teamAGoal, teamBGoal, teamAPenalty, teamBPenalty;
  String langCode = 'en';

  _MatchEditState(this.matchItem);

  @override
  void initState() {
    super.initState();

    teamAGoal = matchItem.teamA_goal;
    teamBGoal = matchItem.teamB_goal;
    teamAPenalty = matchItem.team_a_penalty;
    teamBPenalty = matchItem.team_b_penalty;
    _matchDate = matchItem.match_date;;
    matchDateTimestamp = (matchItem.match_date.millisecondsSinceEpoch / 1000).round();
    apiUpdate = matchItem.api_update;

    LangCode.getLangCode().then((code) {
      setState(() {
        langCode = code;
      });
    });

    _dropDownMenuItems = getDropDownMenuItems();
    _currentStatus = matchItem.status;
    _controller_team_a_goal = new TextEditingController(
        text: teamAGoal.toString()
    );
    _controller_team_b_goal = new TextEditingController(
        text: teamBGoal.toString()
    );
    _controller_team_a_penalty = new TextEditingController(
        text: teamAPenalty.toString()
    );
    _controller_team_b_penalty = new TextEditingController(
        text: teamBPenalty.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['edit_match']),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  matchItem.updateMatch(context, teamAGoal, teamBGoal, teamAPenalty, teamBPenalty,
                      _currentStatus, _matchDate, matchDateTimestamp, apiUpdate).then((result) {
                    setState(() {
                      _isLoading = false;
                    });
                    if(result) {
                      Toast.show(MyLocalizations.instanceLocalization['match_updated'], context,
                          duration: Toast.LENGTH_LONG);
                    }
                    else {
                      Toast.show(MyLocalizations.instanceLocalization['error_occured'], context,
                          duration: Toast.LENGTH_LONG);
                    }
                  });
                });
              },
              child: Text(
                MyLocalizations.instanceLocalization['update'],
                style: TextStyle(
                    color: Colors.white
                ),
              )
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 6.5,
                      height: 100.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: Text(
                        MyLocalizations.instanceLocalization['goal'],
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: Text(
                        MyLocalizations.instanceLocalization['penalty'],
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 6.5,
                      height: 100.0,
                      child: (matchItem.teamA_logo != null && matchItem.teamA_logo.length > 0)?
                      Image.network(
                          matchItem.teamA_logo
                      ): Container(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        matchItem.teamA,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: TextField(
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, //Color of the border
                                  style: BorderStyle.solid, //Style of the border
                                  width: 0.8, //width of the border
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            alignLabelWithHint: true
                        ),
                        textAlign: TextAlign.center,
                        controller: _controller_team_a_goal,
                        maxLines: 1,
                        onChanged: (val){
                          setState((){
                            teamAGoal = int.parse(val);
                          });
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: TextField(
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, //Color of the border
                                  style: BorderStyle.solid, //Style of the border
                                  width: 0.8, //width of the border
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            alignLabelWithHint: true
                        ),
                        textAlign: TextAlign.center,
                        controller: _controller_team_a_penalty,
                        maxLines: 1,
                        onChanged: (val){
                          setState((){
                            teamAPenalty = int.parse(val);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 6.5,
                      height: 100.0,
                      child: (matchItem.teamB_logo != null && matchItem.teamB_logo.length > 0)?
                      Image.network(
                          matchItem.teamB_logo
                      ): Container(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        matchItem.teamB,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: TextField(
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, //Color of the border
                                  style: BorderStyle.solid, //Style of the border
                                  width: 0.8, //width of the border
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            alignLabelWithHint: true
                        ),
                        textAlign: TextAlign.center,
                        controller: _controller_team_b_goal,
                        maxLines: 1,
                        onChanged: (val){
                          setState((){
                            teamBGoal = int.parse(val);
                          });
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: TextField(
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, //Color of the border
                                  style: BorderStyle.solid, //Style of the border
                                  width: 0.8, //width of the border
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            alignLabelWithHint: true
                        ),
                        textAlign: TextAlign.center,
                        controller: _controller_team_b_penalty,
                        maxLines: 1,
                        onChanged: (val){
                          setState((){
                            teamBPenalty = int.parse(val);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        'Match status',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: new DropdownButton(
                        value: _currentStatus,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        'Match date',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: FlatButton(
                        child: Text(
                          constants.formatDateTime(_matchDate, true, langCode)
                        ),
                        onPressed: () {
                          showDate();
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        'Can update from api',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            apiUpdate = value;
                          });
                        },
                        value: apiUpdate,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        dismissible: false,
        color: Colors.black,
        opacity: 0.5,
      ),
    );
  }

  Future showDate() async {
    DateTime date;
    DateTime choice = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: matchItem.match_date?? new DateTime.now(),
      firstDate: new DateTime(2010),
      lastDate: new DateTime(2050),
    );

    if(choice != null) {
      date = choice;
      TimeOfDay timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
      );
      setState(() {
        _matchDate = DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
        matchDateTimestamp = (_matchDate.millisecondsSinceEpoch / 1000).round();
      });
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i=0; i<_statusTitles.length; i++) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: _statusValues[i],
          child: new Text(_statusTitles[i])
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedStatus) {
    setState(() {
      _currentStatus = selectedStatus;
    });
  }

}