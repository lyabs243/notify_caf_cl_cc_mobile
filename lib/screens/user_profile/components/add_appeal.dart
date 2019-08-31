import 'package:flutter/material.dart';

class Appeal extends StatefulWidget{

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
        title: Text('Appeal'),
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
                'Answer the questionnaire to appeal',
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
                    'Do you acknowledge that you violated the terms of use?',
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
                    'After your account is reactivated, will you respect the terms of use?',
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
                labelText: 'Appeal description',
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