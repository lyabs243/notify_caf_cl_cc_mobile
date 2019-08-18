import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/constants.dart' as constants;

class TextTermofuse extends StatelessWidget{

  String title;
  String termUse;

  TextTermofuse(this.title,this.termUse);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        children: [
          new TextSpan(
            text: this.title,
            style: new TextStyle(color: Colors.black,fontSize: 18.0),
          ),
          new TextSpan(
            text: this.termUse,
            style: new TextStyle(color: Colors.blue,fontSize: 18.0),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch(constants.LINK_TERMS_USE);
              },
          ),
        ],
      ),
    );
  }

}