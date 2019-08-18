import 'package:flutter/material.dart';
import '../../../components/icons/login_icons.dart';
import '../../../models/user.dart';
import '../../home/home.dart';

class LoginButton extends StatelessWidget{

  String title;
  LoginType type;
  BuildContext context;

  LoginButton(String title,LoginType type){
    this.title = title;
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new RaisedButton.icon(
      onPressed: (){
        login();
      },
      label: new Text(this.title,textScaleFactor: 1.2,),
      icon: new Icon(
          (this.type == LoginType.Facebook)?
          LoginIcons.facebook :
          (
              (this.type == LoginType.Google)?
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
    bool isLog = await user.login(type);
    if(isLog){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return HomePage();
      }));
    }
  }

}

enum LoginType{
  Google,
  Facebook,
  Nope
}