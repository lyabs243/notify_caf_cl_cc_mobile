import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/body.dart';
import '../../models/localizations.dart';
import '../../models/user.dart';
import 'components/drawer.dart';
import 'components/appbar.dart';
import '../../models/competition_item.dart';

class HomePage extends StatefulWidget{

  Fragment fragment;
  CompetitionItem competitionItem;

  HomePage({Key key, this.title,this.fragment: Fragment.HOME,this.competitionItem}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() {
    // TODO: implement createState
    return new _HomePageState(this.fragment,this.competitionItem);
  }

}

class _HomePageState extends State<HomePage>{

  Fragment fragment;
  User user;
  CompetitionItem competitionItem;

  _HomePageState(this.fragment,this.competitionItem);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User.getInstance().then((user){
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map localization = MyLocalizations.of(context).localization;
    return FutureBuilder<User>(
        future: User.getInstance().then((user){
          this.user = user;
        }),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot){
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: HomeAppBar(user),
              body: Body(fragment: this.fragment,competitionItem: this.competitionItem,),
              drawer: HomeDrawer(user),
            ),
          );;
        }
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(MyLocalizations.instanceLocalization['text_are_you_sure']),
        content: new Text(MyLocalizations.instanceLocalization['text_want_exit_app']),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(MyLocalizations.instanceLocalization['no']),
          ),
          new FlatButton(
            onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: new Text(MyLocalizations.instanceLocalization['yes']),
          ),
        ],
      ),
    )) ?? false;
  }

}