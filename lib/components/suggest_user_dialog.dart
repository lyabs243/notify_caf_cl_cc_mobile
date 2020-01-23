import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestUserDialog extends StatelessWidget {

  Map localization;
  SuggestType suggestType;

  SuggestUserDialog(this.localization, this.suggestType);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 80 / 100,
                child: new Text(
                  (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                  localization['text_suggest_rate_app']:
                  localization['text_suggest_share_app'],
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
              ),
              (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  )
                ],
              ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                      localization['rate']:
                      localization['share'],
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
                      localization['remind_later'],
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
                      localization['not_show_again'],
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
  }

}

enum SuggestType{
  SUGGEST_RATE_APP,
  SUGGEST_SHARE_APP
}