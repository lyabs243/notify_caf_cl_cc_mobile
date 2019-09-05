import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    Map localization = MyLocalizations.of(context).localization;
    return FutureBuilder<User>(
        future: User.getInstance().then((user){
          this.user = user;
        }),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot){
          return Scaffold(
            appBar: HomeAppBar(user,localization),
            body: Body(fragment: this.fragment,competitionItem: this.competitionItem,),
            drawer: HomeDrawer(user, localization),
          );
        }
    );
  }

}