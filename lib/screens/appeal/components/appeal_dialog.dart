import 'package:flutter/material.dart';
import '../../../models/appeal_item.dart';

class AppealDialog extends StatefulWidget{

  Map localization;
  AppealItem appealItem;

  AppealDialog(this.localization,this.appealItem);

  @override
  _AppealDialogState createState() {
    // TODO: implement createState
    return new _AppealDialogState();
  }

}

class _AppealDialogState extends State<AppealDialog>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.localization['appeal']),
        actions: <Widget>[
          FlatButton(
            child: Text(
              this.widget.localization['approve'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: (){

            },
          ),
          FlatButton(
            child: Text(
              this.widget.localization['deactivate'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: (){

            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: Text(
                  this.widget.appealItem.full_name,
                  textScaleFactor: 2.0,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                  color: Theme.of(context).primaryColor
              ),
              child: Text(
                  this.widget.appealItem.register_date.toString(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white
                  ),
                ),
            ),
          Card(
            elevation: 15.0,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  color: (this.widget.appealItem.is_policie_violate)? Colors.green : Colors.red,
                  child: Text(
                    (this.widget.appealItem.is_policie_violate)?
                    this.widget.localization['appeal_recognize_violated_true'] :
                    this.widget.localization['appeal_recognize_violated_false'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  color: (this.widget.appealItem.is_policie_respect_after_activation)? Colors.green : Colors.red,
                  child: Text(
                    (this.widget.appealItem.is_policie_respect_after_activation)?
                    this.widget.localization['appeal_promise_not_violated_true']:
                    this.widget.localization['appeal_promise_not_violated_false'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Text(
                  this.widget.appealItem.appeal_description,
                  textScaleFactor: 1.2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}