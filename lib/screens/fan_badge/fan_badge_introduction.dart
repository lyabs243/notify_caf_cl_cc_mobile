import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/screens/fan_badge/fan_badge_countries.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';

class FanBadgeIntroduction extends StatelessWidget {

  double iconSize;
  double buttonWidth;

  FanBadgeIntroduction();

  @override
  StatelessElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    iconSize = MediaQuery.of(context).size.width/3.5;
    buttonWidth = MediaQuery.of(context).size.width/1.2;
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['fan_badge']),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              child: new Card(
                child: Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
              ),
              width: iconSize,
              height: iconSize,
            ),
            Text(
              MyLocalizations.instanceLocalization['get_badge_introduction_title'],
              textScaleFactor: 2,
              textAlign: TextAlign.center,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: buttonWidth,
                  child: RaisedButton.icon(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return FanBadgeCountries(MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                }));
                          }));
                    },
                    label: new Text(MyLocalizations.instanceLocalization['get_badge'],textScaleFactor: 1.2,),
                    icon: new Icon(
                        Icons.stars
                    ),
                    color: Theme.of(context).primaryColor,
                    elevation: 10.0,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  ),
                ),
                SizedBox(
                  width: buttonWidth,
                  child: RaisedButton.icon(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          }));
                    },
                    label: new Text(MyLocalizations.instanceLocalization['later'],textScaleFactor: 1.2,),
                    icon: new Icon(
                        Icons.watch_later
                    ),
                    color: Theme.of(context).primaryColor,
                    elevation: 10.0,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  ),
                )
              ],
            )
          ],
        ),
    );
  }

}