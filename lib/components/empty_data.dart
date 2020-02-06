import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';

class EmptyData extends StatelessWidget{

  EmptyData();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              child: Image.asset(
                'assets/no_data_found.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              MyLocalizations.instanceLocalization['no_data_found'],
              textScaleFactor: 2.0,
            )
          ],
        ),
      )
    );
  }

}