import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget{

  Map localization;

  EmptyData(this.localization);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
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
            localization['no_data_found'],
            textScaleFactor: 2.0,
          )
        ],
      ),
    );
  }

}