import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../models/localizations.dart';
import '../login/login.dart';
import '../../models/user.dart';
import 'components/drawer.dart';
import 'components/appbar.dart';

class HomePage extends StatefulWidget{

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  User user;

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
            body: Body(),
            drawer: HomeDrawer(user, localization),
          );
        }
    );
  }

}