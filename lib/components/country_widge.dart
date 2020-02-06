import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/Country.dart';
import 'package:flutter_cafclcc/screens/fan_badge/get_fan_badge.dart';

class CountryWidget extends StatelessWidget {

  Country country;
  MaterialPageRoute materialPageRoute;

  double iconSize;

  CountryWidget(this.country, this.materialPageRoute);

  @override
  Widget build(BuildContext context) {
    iconSize = MediaQuery.of(context).size.width/8;
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
            return GetFanBadge(country, materialPageRoute);
          })
          );
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