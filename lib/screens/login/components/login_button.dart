import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/screens/fan_badge/fan_badge_introduction.dart';
import '../../../components/icons/login_icons.dart';
import '../../../models/user.dart';
import '../../home/home.dart';
import 'package:toast/toast.dart';

class LoginButton extends StatefulWidget{

  String title;
  LoginType type;
  Function seLoginState;
  Map localization;

  LoginButton(this.title,this.type,this.seLoginState,this.localization);

  @override
  _LoginButton createState() {
    // TODO: implement createState
    return new _LoginButton();
  }

}

class _LoginButton extends State<LoginButton>{

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new RaisedButton.icon(
      onPressed: (){
        login();
      },
      label: new Text(this.widget.title,textScaleFactor: 1.2,),
      icon: new Icon(
          (this.widget.type == LoginType.Facebook)?
          LoginIcons.facebook :
          (
              (this.widget.type == LoginType.Google)?
              LoginIcons.google :
              Icons.warning
          )
      ),
      color: Theme.of(context).primaryColor,
      elevation: 10.0,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );
  }

  login() async{
    User user = new User();
    bool isLog = await user.login(widget.type,this.widget.seLoginState,context);
    if(isLog){
      User.currentUser = null;
      //suggest to get a badge
      if(this.widget.type == LoginType.Facebook || this.widget.type == LoginType.Google) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
          return FanBadgeIntroduction(this.widget.localization);
        }));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) {
          return HomePage(this.widget.localization);
        }));
      }
    }
    else{
      Toast.show(this.widget.localization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

}

enum LoginType{
  Google,
  Facebook,
  Nope
}