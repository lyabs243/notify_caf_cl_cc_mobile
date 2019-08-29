import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ItemAppeal extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: 5,
        itemBuilder: ((context,i){
          return Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: new TextSpan(
                          text: 'Item $i',
                          style: new TextStyle(
                              color: Theme.of(context).textTheme.body1.color,fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {

                            },
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 5.0),),
                  Text(
                    'Bla bla bla bal je viens chez toi pour blaguer ne menerve pas Bla bla bla bal je viens chez toi pour blaguer ne menerve pas Bla bla bla bal je viens chez toi pour blaguer ne menerve pas: $i',
                    maxLines: 3,
                  )
                ],
              ),
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
            ),
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          );
        }));
  }

}