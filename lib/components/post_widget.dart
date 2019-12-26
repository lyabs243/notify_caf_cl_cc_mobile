import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_reaction_box.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';

class PostWidget extends StatefulWidget {

  Map localization;
  Post post;

  PostWidget(this.localization, this.post);

  @override
  _PostWidgetState createState() {
    return new _PostWidgetState(this.localization, this.post);
  }

}

class _PostWidgetState extends State<PostWidget> {

  Map localization;
  Post post;

  bool showReactionBox = false;

  String postM = '''Je reçois souvent des questions sur pepele mobile et ces questions tournent généralement autour des transferts,
                  Je suis heureux de vous informer que désormais, tous ceux qui désirent envoyer ou recevoir de l argent sur leurs comptes pepele n auront plus à supporter des frais de transfert.
                  Avec pepele mobile, c est simple c est rapide et c est efficace. Faites le bon choix et ouvrez des comptes pepele soit en ligne soit dans l agence TMB la proche ou encore chez l un de nos agents indépendants agréées.''';

  _PostWidgetState(this.localization, this.post);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = new User();
    user.url_profil_pic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBsB2N63pma9aEi5JYrsrDe-ucm8sSddkiGBkqHL3gsYwj2CahLQ&s';
    return Stack(
      children: <Widget>[
        Card(
          elevation: 15.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
                    Text(
                      'Jeanne Lacourte',
                      textScaleFactor: 1.1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: (postM.length > 150)?
                        postM.substring(0, 150):
                        postM,
                        style: new TextStyle(color: Theme.of(context).textTheme.body1.color),
                      ),
                      (postM.length > 150)?
                      new TextSpan(
                        text: '...${localization['see_more']}',
                        style: new TextStyle(color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {

                          },
                      ):
                      TextSpan(),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0)),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Image.network(
                    'https://media.licdn.com/dms/image/C4D22AQFkpXyk0Y1-DA/feedshare-shrink_2048_1536/0?e=1580342400&v=beta&t=_NwjrXJXXAcTCTQqBfM0wXEMMvT1Ig3c1Ylu2NatXZw',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/reaction/offside.jpg',
                          height: 20.0,
                        ),
                        Image.asset(
                          'assets/icons/reaction/goal.png',
                          height: 20.0,
                        ),
                        Image.asset(
                          'assets/icons/reaction/angry.png',
                          height: 20.0,
                        ),
                        Text('12')
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey[800],
                ),
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () {
                          setState(() {
                            showReactionBox = !showReactionBox;
                          });
                        },
                        icon: ImageIcon(AssetImage('assets/icons/reaction/like_empty.png'), size: 20.0),
                        label: Text('Like')
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        (showReactionBox)?
        Positioned(
          child: PostReactionBox(localization),
          right: 40.0,
          bottom: 60.0,
        ):
        Container()
      ],
    );
  }

}