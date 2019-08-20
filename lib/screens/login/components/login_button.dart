import 'package:flutter/material.dart';
import '../../../components/icons/login_icons.dart';
import '../../../models/user.dart';
import '../../home/home.dart';

class LoginButton extends StatefulWidget{

  String title;
  LoginType type;
  Function seLoginState;

  LoginButton(this.title,this.type,this.seLoginState);

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
    bool isLog = await user.login(widget.type,this.widget.seLoginState);
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