import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/constants.dart' as constants;

class AboutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['about']),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width /3,
                  height: MediaQuery.of(context).size.width /3,
                  child: Image.asset(
                    'assets/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0),),
              Container(
                child: Text(
                  MyLocalizations.instanceLocalization['app_title'],
                  textScaleFactor: 2.5,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Version ${constants.APP_VERSION}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0),),
              Container(
                child: Text(
                  MyLocalizations.instanceLocalization['about_text'],
                  textScaleFactor: 1.4,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0),),
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: RaisedButton.icon(
                        onPressed: () {
                          launch('https://play.google.com/store/apps/details?id=${constants.APP_PACKAGE}');
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        label: Text(
                          MyLocalizations.instanceLocalization['rate'],
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: RaisedButton.icon(
                        onPressed: () {
                          Share.share(MyLocalizations.instanceLocalization['text_share_app']);
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        label: Text(
                          MyLocalizations.instanceLocalization['share'],
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: RaisedButton.icon(
                        onPressed: () {
                          launch(constants.LINK_TERMS_USE);
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        label: Text(
                          MyLocalizations.instanceLocalization['term_use'],
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}