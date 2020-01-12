import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/badge_layout.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/models/Country.dart';
import 'package:flutter_cafclcc/models/competition_item.dart';
import 'package:flutter_cafclcc/models/fan_badge.dart';
import 'package:flutter_cafclcc/models/fan_club.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GetFanBadge extends StatefulWidget {

  Map localization;
  Country country;

  GetFanBadge(this.localization, this.country);

  @override
  _GetFanBadgeState createState() {
    return _GetFanBadgeState(this.localization, this.country);
  }

}

class _GetFanBadgeState extends State<GetFanBadge> {

  Map localization;
  Country country;

  User currentUser;

  List<Widget> allClubs = [];

  List<FanClub> clubs = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true;

  double iconSize;

  _GetFanBadgeState(this.localization, this.country);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    User.getInstance().then((_user) {
      setState(() {
        currentUser = _user;
        if(this.clubs.length == 0) {
          initItems();
        }
      });
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    iconSize = MediaQuery.of(context).size.width/3.5;
    return Scaffold(
        appBar: AppBar(
          title: Text(country.nicename),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage(localization);
                      })
                  );
                }
            )
          ],
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          header: (WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).primaryColor,
          )   ),
          child: (isLoadPage)?
          Center(
            child: CircularProgressIndicator(),
          ):
          (clubs.length <= 0)?
          EmptyData(this.widget.localization):
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: new Card(
                    child:
                    (country.url_flag != null && country.url_flag.length > 0)?
                     Image.network(country.url_flag, fit: BoxFit.cover,):
                    Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
                  ),
                  width: iconSize,
                  height: iconSize,
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0),),
                Text(
                  localization['get_badge_now'],
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.5,
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0),),
                Expanded(
                  child: Wrap(
                    children: allClubs,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  initItems() async{
    await Future.delayed(Duration.zero);
    FanClub.getClubs(context, country.country_code, CompetitionItem.COMPETITION_TYPE).then((value){
      setState(() {
        clubs = value;
        allClubs.clear();
        clubs.forEach((club) {
          FanBadge badge = new FanBadge(currentUser.id_subscriber, club.id, club.category, club.title, club.country_code,
              club.url_logo, club.top_club, club.color);
          allClubs.add(
            InkWell(
              child: Container(
                child: BadgeLayout(localization, badge),
                padding: EdgeInsets.only(left: 4.0, right: 4.0),
              ),
              onTap: () {

              },
            )
          );
        });
        isLoadPage = false;
      });
    });
  }

  void _onRefresh() async{
    setState(() {
      isPageRefresh = true;
      isLoadPage = true;
    });
    await initItems();
    refreshController.refreshCompleted();
  }

}