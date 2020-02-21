import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:flutter_cafclcc/screens/login/login.dart';
import 'package:http/http.dart';
import 'package:onesignal/onesignal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/constants.dart' as constants;

class FirstLaunchPage extends StatefulWidget {

  User user;

  FirstLaunchPage(this.user);

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
  bool receiveNotifications = true;

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
                      MyLocalizations.instanceLocalization['previous'],
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
                      MyLocalizations.instanceLocalization['finish']:
                      MyLocalizations.instanceLocalization['next'],
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
                            return HomePage();
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
            MyLocalizations.instanceLocalization['first_launch_title_1'],
            MyLocalizations.instanceLocalization['first_launch_description_1'],
          'assets/screenshots/home.PNG'
        )
      );

    slideChilds.add(
        buildSlideItem
          (
            MyLocalizations.instanceLocalization['first_launch_title_2'],
            MyLocalizations.instanceLocalization['first_launch_description_2'],
            'assets/screenshots/score.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            MyLocalizations.instanceLocalization['first_launch_title_3'],
            MyLocalizations.instanceLocalization['first_launch_description_3'],
            'assets/screenshots/competition_details.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            MyLocalizations.instanceLocalization['first_launch_title_4'],
            MyLocalizations.instanceLocalization['first_launch_description_4'],
            'assets/screenshots/badge.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            MyLocalizations.instanceLocalization['first_launch_title_5'],
            MyLocalizations.instanceLocalization['first_launch_description_5'],
            'assets/screenshots/community.PNG'
        )
    );

    slideChilds.add(
        buildSlideItem
          (
            MyLocalizations.instanceLocalization['first_launch_title_6'],
            MyLocalizations.instanceLocalization['first_launch_description_6'],
            'assets/icons/let_start.png',
            lastSlide: true
        )
    );

    return slideChilds;
  }

  Widget buildSlideItem(String title, String description, String asset, {bool lastSlide: false}) {
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
                (lastSlide)?
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween
                        ,children: <Widget>[
                          Container(
                            child: Text(
                              MyLocalizations.instanceLocalization['receive_notification_on_fixture_action'],
                              style: TextStyle(
                                color: Colors.white
                              ),
                              textScaleFactor: 1.5,
                            ),
                            width: MediaQuery.of(context).size.width /1.8,
                          ),
                          Container(
                            child: CircleAvatar(
                              radius: 30.0,
                              child: ClipOval(
                                child: Switch(
                                  value: receiveNotifications,
                                  onChanged: (value) {
                                    OneSignal.shared.setSubscription(value).then((val) {
                                      constants.setOnesignalSubscription(value);
                                    });
                                    setState(() {
                                      receiveNotifications = value;
                                    });
                                  },
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: Text(
                          MyLocalizations.instanceLocalization['can_modify_choice'],
                          style: TextStyle(
                              color: Colors.white
                          ),
                          textScaleFactor: 1.2,
                        ),
                      )
                    ],
                  ),
                ):
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