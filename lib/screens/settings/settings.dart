import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/Select_language_widget.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:onesignal/onesignal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/constants.dart' as constants;

class Settings extends StatefulWidget {

  Settings();

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }

}

class _SettingsState extends State<Settings> {

  String langCode;
  bool isLoading = true, receiveNotifications = true;

  _SettingsState();

  @override
  void initState() {
    super.initState();
    constants.getOnesignalSubscription().then((value) {
      setState(() {
        receiveNotifications = true;
      });
    });
    SharedPreferences.getInstance().then((sharedPreferences) {
      setState(() {
        langCode = sharedPreferences.getString('lang');
        if(langCode == null) {
          langCode = 'en';
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['settings']),
      ),
      body: (isLoading == true)?
      Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                MyLocalizations.instanceLocalization['Language'],
                textScaleFactor: 1.2,
                style: TextStyle(
                    color: Theme.of(context).textTheme.body1.color
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SelectLanguageWidget(null, goToHomePage: true,);
                })).then((lang) {
                  if(lang != null) {
                    setState(() {
                      langCode = lang;
                    });
                  }
                });
              },
              leading: ImageIcon(AssetImage('assets/icons/date.png'),color: Theme.of(context).primaryColor),
              trailing: Text(
                  (langCode == 'fr')?
                  MyLocalizations.instanceLocalization['french']:
                  MyLocalizations.instanceLocalization['english'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
              ),
            ),
            ListTile(
              title: Text(
                MyLocalizations.instanceLocalization['receive_notification_on_fixture_action'],
                textScaleFactor: 1.2,
                style: TextStyle(
                    color: Theme.of(context).textTheme.body1.color
                ),
              ),
              onTap: (){

              },
              leading: Icon
              (
                (receiveNotifications)?
                Icons.notifications_active:
                Icons.notifications_off,
                color: Theme.of(context).primaryColor
              ),
              trailing: Container(
                child: Switch(
                  value: receiveNotifications,
                  onChanged: (value) {
                    OneSignal.shared.setSubscription(value).then((val) {
                      constants.setOnesignalSubscription(value);
                    });
                    setState(() {
                      receiveNotifications = value;
                    });
                  },
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}