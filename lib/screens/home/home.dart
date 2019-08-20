import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../models/localizations.dart';
import '../login/login.dart';
import '../../models/user.dart';

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
            appBar: AppBar(
              title: Text(localization['app_title']),
              actions: <Widget>[
                (user == null || user.id_accout_type == User.NOT_CONNECTED_ACCOUNT_ID) ?
                new FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return Login();
                      }));
                    },
                    child: Text(localization['login'],style: TextStyle(color: Colors.white),)
                ) :
                new Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(top: 9.0,bottom: 9.0, right: 5.0),
                  child: (user != null && user.url_profil_pic != null)?
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                    NetworkImage(user.url_profil_pic),
                    backgroundColor: Colors.transparent,
                  ):
                  Icon(Icons.supervised_user_circle),
                )
              ],
            ),
            body: Body(),
          );
        }
    );
  }

}