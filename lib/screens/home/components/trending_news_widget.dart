import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class TrendingNewsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 30.0,
      child: new Container(
        margin: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                color: /*const Color(0xff7c94b6)*/Colors.black,
                borderRadius: BorderRadius.circular(5),
                image: new DecorationImage(
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                  image: new NetworkImage('https://pbs.twimg.com/profile_images/939161800037355520/lvGNqhFT_400x400.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    'Le titre de l\'article !!! shssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss',
                    maxLines: 2,
                    textScaleFactor: 1.5,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: <Widget>[
                        ImageIcon(AssetImage('assets/icons/date.png'),size: 15.0, color: Colors.white,),
                        Padding(padding: EdgeInsets.only(left: 2.0,right: 2.0),),
                        new Text(
                          'il y a 2 ans',
                          maxLines: 1,
                          style: new TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 4.5,
            ),
          ],
        ),
      ),
    );
  }

}