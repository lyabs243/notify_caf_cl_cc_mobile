import 'package:flutter/material.dart';

class PageTransition {

  Map localization;
  BuildContext context;

  PageTransition (this.context, this.localization);

  //check if app can suggest user to share or rate application
  Future checkForRateAndShareSuggestion() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 150,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 80 / 100,
                      child: new Text('Hello world'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            localization['add'],
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            localization['cancel'],
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ]
              ),
            ),
          );
        });
  }
}