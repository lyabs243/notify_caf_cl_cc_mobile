import 'package:flutter/material.dart';

class Appeal extends StatefulWidget{

  Map localization;

  Appeal(this.localization);

  @override
  _AppealState createState() {
    // TODO: implement createState
    return new _AppealState();
  }

}

class _AppealState extends State<Appeal>{

  bool isRecongnizeViolated = false;
  bool isViolatedAgain = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.localization['appeal']),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 20.0),),
            Center(
              child: Text(
                this.widget.localization['answer_questionnaire_appeal'],
                textScaleFactor: 1.5,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    this.widget.localization['is_recognize_violated_terms'],
                    textScaleFactor: 1.4,
                  ),
                ),
                Checkbox(
                    value: isRecongnizeViolated,
                    onChanged: (value){
                      setState(() {
                        isRecongnizeViolated = value;
                      });
                    }
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    this.widget.localization['is_recognize_not_violated_terms_after_activate'],
                    textScaleFactor: 1.4,
                  ),
                ),
                Checkbox(
                    value: isViolatedAgain,
                    onChanged: (value){
                      setState(() {
                        isViolatedAgain = value;
                      });
                    }
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0),),
            TextField(
              decoration: new InputDecoration(
                labelText: this.widget.localization['appeal_description'],
                alignLabelWithHint: true
              ),
              maxLines: 10,
              maxLength: 1000,
            ),
          ],
        ),
      ),
    );
  }

}