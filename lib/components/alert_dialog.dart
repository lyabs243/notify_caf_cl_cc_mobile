import 'package:flutter/material.dart';

bool showAlertDialog(BuildContext context,String title,String content,Map localization,Function onValidate) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Row(
          children: <Widget>[
            Icon(Icons.warning,color: Theme.of(context).primaryColor,),
            Text(title),
          ],
        ),
        content: new Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(localization['no']),
            onPressed: () {
              Navigator.of(context).pop();
              return false;
            },
          ),
          new FlatButton(
            child: new Text(localization['yes']),
            onPressed: () {
              Navigator.of(context).pop();
              onValidate();
              return true;
            },
          ),
        ],
      );
    },
  );
}