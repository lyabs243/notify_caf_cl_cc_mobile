import 'package:flutter/material.dart';
import 'components/login_button.dart';

class Login extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    double buttonWidth = MediaQuery.of(context).size.width/1.2;
    double iconSize = MediaQuery.of(context).size.width/2.5;

    // TODO: implement build
    return new Container(
      color: Colors.white,
      child: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              child: new Card(
                elevation: 10.0,
                child: Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
              ),
              width: iconSize,
              height: iconSize,
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton('Login with Google', LoginType.Google),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton('Login with Facebook', LoginType.Facebook),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton('Continue without login', LoginType.Nope),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}