import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/country_widge.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/models/Country.dart';
import 'package:flutter_cafclcc/models/competition_item.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FanBadgeCountries extends StatefulWidget {

  Map localization;
  MaterialPageRoute materialPageRoute;

  FanBadgeCountries(this.localization, this.materialPageRoute);

  @override
  _FanBadgeCountriesState createState() {
    return _FanBadgeCountriesState(this.localization);
  }

}

class _FanBadgeCountriesState extends State<FanBadgeCountries> {

  Map localization;
  double iconSize;

  List<Country> countries = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true;

  _FanBadgeCountriesState(this.localization);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    if(this.countries.length == 0) {
      initItems();
    }
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
        title: Text(localization['countries']),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, this.widget.materialPageRoute);
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
        (countries.length <= 0)?
        EmptyData(this.widget.localization):
        Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: new Card(
                child: Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
              ),
              width: iconSize,
              height: iconSize,
            ),
            Padding(padding: EdgeInsets.only(bottom: 8.0),),
            Text(
              localization['select_club_country'],
              textAlign: TextAlign.center,
              textScaleFactor: 2.5,
            ),
            Padding(padding: EdgeInsets.only(bottom: 8.0),),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index){
                  return CountryWidget(localization, countries[index], this.widget.materialPageRoute);
                },
                itemCount: countries.length,
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
    Country.getCountriesClub(context, CompetitionItem.COMPETITION_TYPE).then((value){
      setState(() {
        countries = value;
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