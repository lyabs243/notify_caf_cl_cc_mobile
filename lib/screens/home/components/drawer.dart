import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/screens/community/community.dart';
import '../../../models/drawer_item.dart';
import '../../../models/user.dart';
import '../../../screens/login/login.dart';
import '../../../screens/user_profile/user_profile.dart';
import '../../../screens/appeal/appeal_page.dart';
import '../../../models/competition_item.dart';
import '../../../components/no_animation_pageroute.dart';
import 'body.dart';
import '../home.dart';
import '../../competition/competition.dart';
import '../../news_list/news_list.dart';

class HomeDrawer extends StatefulWidget{

	Map localization;
	User user;

	HomeDrawer(this.user,this.localization);

	@override
	_HomeDrawerState createState() {
		// TODO: implement createState
		return new _HomeDrawerState();
	}

}

class _HomeDrawerState extends State<HomeDrawer>{

	List<DrawerItem> drawerItems;
	bool isExpand = false;

	@override
	void initState() {
		// TODO: implement initState
		super.initState();
		drawerItems = new List<DrawerItem>();
		initDrawerItems();
	}

	@override
	void setState(fn) {
		if(mounted){
			super.setState(fn);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: Container(
				decoration: new BoxDecoration(
					borderRadius: BorderRadius.circular(5),
					image: new DecorationImage(
						image: new AssetImage('assets/bg_nav.jpg'),
						fit: BoxFit.cover,
					),
				),
				child: ListView.builder(
					itemBuilder: ((context,i){
						if(i == 0){
							return Container(
								child: Row(
									children: <Widget>[
										Container(
											width: 80.0,
											height: 80.0,
											child: Image.asset('assets/app_icon_white.png'),
										),
										new Text(
											this.widget.localization['app_title'],
											textScaleFactor: 1.8,
											style: TextStyle(
												color: Colors.white,
												fontWeight: FontWeight.bold
											),
										)
									],
								),
							);
						}
						else if(drawerItems[i].drawerType == DrawerType.expandable){
							return ExpansionTile(
								title: Text(
									drawerItems[i].title,
									textScaleFactor: 1.2,
									style: TextStyle(
											color: Colors.white
									),
								),
								trailing: (isExpand)?
								Icon(Icons.expand_less,color: Colors.white,):
								Icon(Icons.expand_more,color: Colors.white,),
								onExpansionChanged: (val){
									setState(() {
										isExpand = val;
									});
								},
								leading: (drawerItems[i].iconPath != null) ?
									ImageIcon(AssetImage(drawerItems[i].iconPath),color: Colors.white) :
									null,
								children: <Widget>[
									Padding(
										padding: const EdgeInsets.symmetric(horizontal: 16.0),
										child: Align(
											alignment: Alignment.topLeft,
											child: Column(
												mainAxisSize: MainAxisSize.min,
												children: drawerItems[i].expandableItems,
											),
										),
									),
								],
							);
						}
						else if(!drawerItems[i].visible){
							return Container();
						}
						else{
							return new ListTile(
								title: Text(
									drawerItems[i].title,
									textScaleFactor: 1.2,
									style: TextStyle(
										color: Colors.white
									),
								),
								onTap: (){
									Navigator.pop(context);
									onDrawerItemSelected(i);
								},
								leading: (drawerItems[i].iconPath != null) ?
									ImageIcon(AssetImage(drawerItems[i].iconPath),color: Colors.white) :
									null,
							);
						}
					}),
					itemCount: drawerItems.length,
				),
			),
		);
	}

	initDrawerItems(){

		DrawerItem header = new DrawerItem(0, this.widget.localization['app_title'], DrawerType.header);
		List competitions = initCompetitions();
		DrawerItem home = new DrawerItem(1, this.widget.localization['home'], DrawerType.item,iconPath: 'assets/icons/login.png');
		DrawerItem news = new DrawerItem(2, this.widget.localization['news'], DrawerType.item,iconPath: 'assets/icons/latest.png');
		DrawerItem community = new DrawerItem(3, this.widget.localization['community'], DrawerType.item,iconPath: 'assets/icons/login.png');
		DrawerItem competition = new DrawerItem(4, this.widget.localization['competition'], DrawerType.expandable,
				iconPath: 'assets/icons/profile.png',expandableItems: competitions);
		DrawerItem profil = new DrawerItem(5, this.widget.localization['profil'], DrawerType.item,iconPath: 'assets/icons/profile.png');
		DrawerItem appeal = new DrawerItem(6, this.widget.localization['subscriber_appeal'], DrawerType.item,iconPath: 'assets/icons/logout.png',visible: false);
		DrawerItem login = new DrawerItem(7, this.widget.localization['login'], DrawerType.item,iconPath: 'assets/icons/login.png');
		DrawerItem logout = new DrawerItem(8, this.widget.localization['logout'], DrawerType.item,iconPath: 'assets/icons/logout.png');

		//set visibility
		if(this.widget.user.id_accout_type == User.NOT_CONNECTED_ACCOUNT_ID){
			profil.visible = false;
			community.visible = false;
			logout.visible = false;
		}
		else{
			login.visible = false;
			if(this.widget.user.type == User.USER_TYPE_ADMIN){
				appeal.visible = true;
			}
		}

		drawerItems.add(header);
		drawerItems.add(home);
		drawerItems.add(news);
		drawerItems.add(community);
		drawerItems.add(competition);
		drawerItems.add(profil);
		drawerItems.add(appeal);
		drawerItems.add(login);
		drawerItems.add(logout);
	}

	onDrawerItemSelected(int id){
		switch(id){
			case 1: //click on home
				Navigator.pushReplacement(
						context,
						NoAnimationMaterialPageRoute(
								builder: (BuildContext context){
									return HomePage(this.widget.localization,fragment: Fragment.HOME,);
								}
						));
				break;
			case 2: //click on news
				Navigator.push(
						context,
						MaterialPageRoute(
								builder: (BuildContext context){
									return NewsList(this.widget.localization, CompetitionItem.COMPETITION_TYPE);
								}
						));
				break;
			case 3: //click on community
				Navigator.push(
						context,
						MaterialPageRoute(
								builder: (BuildContext context){
									return Community(this.widget.localization);
								}
						));
				break;
			case 5: //click on profil
				Navigator.push(
						context,
						MaterialPageRoute
							(
								builder: (BuildContext context){
									return UserProfile(this.widget.user,this.widget.user,this.widget.localization);
								}
						));
				break;
			case 6: //click on appeal
				Navigator.push(
						context,
						MaterialPageRoute
							(
								builder: (BuildContext context){
									return AppealPage(this.widget.localization);
								}
						));
				break;
			case 7: //click on login
				Navigator.pushReplacement(
					context,
					MaterialPageRoute
					(
							builder: (BuildContext context){
								return Login();
							}
					));
				break;
			case 8: //click on logout
				Navigator.pushReplacement(
						context,
						MaterialPageRoute(
								builder: (BuildContext context){
									this.widget.user.logout();
									return Login();
								}
						));
				break;
		}
	}

	//init competion list
	List<Widget> initCompetitions(){

		CompetitionItem champions_league = new CompetitionItem(2, this.widget.localization['champions_league'],
        null, '','',1,null);
		CompetitionItem confederation_cup = new CompetitionItem(3, this.widget.localization['confederation_cup'],
        null, '','',1,null);

		List<CompetitionItem> competitions = [champions_league,confederation_cup];

		DrawerItem drawerCL = new DrawerItem(0, competitions[0].title, DrawerType.item);
		DrawerItem drawerCC = new DrawerItem(1, competitions[1].title, DrawerType.item);
		DrawerItem drawerMore = new DrawerItem(2, this.widget.localization['more'], DrawerType.item);

		List competitionDrawerItems = [];
		competitionDrawerItems.add(drawerCL);
		competitionDrawerItems.add(drawerCC);
		competitionDrawerItems.add(drawerMore);

		List<Widget> listWidget = [];

		competitionDrawerItems.forEach((item){
			listWidget.add(
				InkWell(
					child: Row(
						children: <Widget>[
							Padding(padding: EdgeInsets.only(left: 50.0)),
							Text(
							  item.title,
								textScaleFactor: 1,
								  style: TextStyle(
									color: Colors.white,
								),
							),
						],
					),
					onTap: (){
					  switch(item.id){
						  case 0://champoions league
							case 1://confederation cup
							  Navigator.push(
								  context,
                  MaterialPageRoute(
									  builder: (BuildContext context){
										  return CompetitionPage(competitions[item.id],this.widget.localization);
										}
									));
							  break;
							case 2://more
							  Navigator.pushReplacement(
								  context,
									NoAnimationMaterialPageRoute(
									  builder: (BuildContext context){
										  return HomePage(this.widget.localization,fragment: Fragment.COMPETITION_LIST,);
										}
									));
								break;
							}
						}
				),
			);
			listWidget.add(Padding(padding: EdgeInsets.only(bottom: 18.0)));
		});

		return listWidget;
	}

}