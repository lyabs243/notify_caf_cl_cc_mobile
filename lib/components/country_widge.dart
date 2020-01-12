import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/Country.dart';

class CountryWidget extends StatelessWidget {

  Map localization;
  Country country;

  double iconSize;

  CountryWidget(this.localization, this.country);

  @override
  Widget build(BuildContext context) {
    iconSize = MediaQuery.of(context).size.width/8;
    return Container(
      child: InkWell(
        onTap: () {

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: iconSize,
              height: iconSize,
              child: (country.url_flag != null && country.url_flag.length > 0)?
              Image.network(country.url_flag, fit: BoxFit.cover,) :
              Image.asset('assets/icons/privacy.png', fit: BoxFit.cover,),
            ),
            Text(
              country.nicename,
              textScaleFactor: 1.2,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
      margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
    );
  }

}