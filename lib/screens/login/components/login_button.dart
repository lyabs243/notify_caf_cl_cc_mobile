import 'package:flutter/material.dart';
import '../../../components/icons/login_icons.dart';

class LoginButton extends StatelessWidget{

  String title;
  LoginType type;

  LoginButton(String title,LoginType type){
    this.title = title;
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    return new RaisedButton.icon(
      onPressed: (){

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
      color: Colors.green,
      elevation: 10.0,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );
  }

}

enum LoginType{
  Google,
  Facebook,
  Nope
}