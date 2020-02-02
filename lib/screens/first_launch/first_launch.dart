import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:flutter_cafclcc/screens/login/login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLaunchPage extends StatefulWidget {

  Map localization;
  User user;

  FirstLaunchPage(this.localization, this.user);

  @override
  _FirstLaunchPageState createState() => _FirstLaunchPageState();

  static Future<bool> isFirstLaunch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool firstLaunch = sharedPreferences.getBool('first_launch');
    if(firstLaunch == null) {
      firstLaunch = true;
    }
    return firstLaunch;
  }

  static Future setFirstLaunch(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('first_launch', value);
  }
}

class _FirstLaunchPageState extends State<FirstLaunchPage> {

  int _current = 0;
  CarouselSlider carouselSlider;
  List<Widget> childs = [];

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    childs = getChilds(context);
    carouselSlider = CarouselSlider(
      items: childs,
      height: MediaQuery.of(context).size.height / 1.1,
      autoPlay: false,
      enableInfiniteScroll: false,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Stack(
              children: [
                carouselSlider,
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(childs, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index ? Color.fromRGBO(255, 255, 255, 0.9) :
                              Color.fromRGBO(255, 255, 255, 0.4)
                          ),
                        );
                      }),
                    )
                ),
              ]
          ),
          Container(
            color: Color.fromRGBO(255, 255, 255, 0.4),
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (_current == 0)?
              Container():
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    Text(
                      this.widget.localization['previous'],
                      textScaleFactor: 1.2,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  carouselSlider.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                },
              ),
              FlatButton(
                child: Row(
                  children: [
                    Text(
                      (_current == childs.length - 1)?
                      this.widget.localization['finish']:
                      this.widget.localization['next'],
                      textScaleFactor: 1.2,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () {
                  if (_current == childs.length - 1) {
                    FirstLaunchPage.setFirstLaunch(false);
                    if (this.widget.user != null && this.widget.user.id_accout_type != null &&
                        this.widget.user.id_accout_type != null){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_context){
                            return HomePage(this.widget.localization);
                          }
                      ));
                    }
                    else {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_context){
                            return Login();
                          }
                      ));
                    }
                  }
                  else {
                    carouselSlider.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> getChilds(BuildContext context) {
    List<Widget> slideChilds = [];

    slideChilds.add(
        buildSlideItem
        (
          this.widget.localization['first_launch_title_1'],
          this.widget.localization['first_launch_description_1'],
          'assets/screenshots/home.PNG'
        )
      );

    slideChilds.add(
        buildSlideItem
          (
            this.widget.localization['first_launch_title_2'],
            this.widget.localization['first_launch_description_2'],
            'assets/screenshots/score.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            this.widget.localization['first_launch_title_3'],
            this.widget.localization['first_launch_description_3'],
            'assets/screenshots/competition_details.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            this.widget.localization['first_launch_title_4'],
            this.widget.localization['first_launch_description_4'],
            'assets/screenshots/badge.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            this.widget.localization['first_launch_title_5'],
            this.widget.localization['first_launch_description_5'],
            'assets/screenshots/community.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            this.widget.localization['first_launch_title_6'],
            this.widget.localization['first_launch_description_6'],
            'assets/icons/let_start.png'
        )
    );

    return slideChilds;
  }

  Widget buildSlideItem(String title, String description, String asset) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height /20, bottom: MediaQuery.of(context).size.height /20),
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    title,
                    textScaleFactor: 2.0,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 25,
                ),
                Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0),),
                Container(
                  child: Text(
                    description,
                    textScaleFactor: 1.1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0),),
                Container(
                  width: MediaQuery.of(context).size.width/1.5,
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Card(
                    elevation: 80.0,
                    child: Image.asset(
                      asset,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}