import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/about_screen.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/screens/admin_panel/admin_panel.dart';
import 'package:flutter_cafclcc/screens/community/community.dart';
import 'package:flutter_cafclcc/screens/competition_list/competition_list.dart';
import 'package:flutter_cafclcc/screens/settings/settings.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
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

	User user;

	HomeDrawer(this.user);

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
											MyLocalizations.instanceLocalization['app_title'],
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

		DrawerItem header = new DrawerItem(0, MyLocalizations.instanceLocalization['app_title'], DrawerType.header);
		List competitions;
		initCompetitions().then((result) {
			setState(() {
				competitions = result;
				DrawerItem home = new DrawerItem(1, MyLocalizations.instanceLocalization['home'], DrawerType.item,iconPath: 'assets/icons/login.png');
				DrawerItem news = new DrawerItem(2, MyLocalizations.instanceLocalization['news'], DrawerType.item,iconPath: 'assets/icons/latest.png');
				DrawerItem community = new DrawerItem(3, MyLocalizations.instanceLocalization['community'], DrawerType.item,iconPath: 'assets/icons/login.png');
				DrawerItem competition = new DrawerItem(4, MyLocalizations.instanceLocalization['competition'], DrawerType.expandable,
						iconPath: 'assets/icons/profile.png',expandableItems: competitions);
				DrawerItem profil = new DrawerItem(5, MyLocalizations.instanceLocalization['profil'], DrawerType.item,iconPath: 'assets/icons/profile.png');
				DrawerItem admin_panel = new DrawerItem(6, MyLocalizations.instanceLocalization['admin_panel'], DrawerType.item,iconPath: 'assets/icons/logout.png',visible: false);
				DrawerItem settings = new DrawerItem(7, MyLocalizations.instanceLocalization['settings'], DrawerType.item,iconPath: 'assets/icons/date.png');
				DrawerItem about = new DrawerItem(8, MyLocalizations.instanceLocalization['about'], DrawerType.item,iconPath: 'assets/icons/latest.png');
				DrawerItem login = new DrawerItem(9, MyLocalizations.instanceLocalization['login'], DrawerType.item,iconPath: 'assets/icons/login.png');
				DrawerItem logout = new DrawerItem(10, MyLocalizations.instanceLocalization['logout'], DrawerType.item,iconPath: 'assets/icons/logout.png');

				//set visibility
				if(this.widget.user.id_accout_type == User.NOT_CONNECTED_ACCOUNT_ID){
					profil.visible = false;
					community.visible = false;
					logout.visible = false;
				}
				else{
					login.visible = false;
					if(this.widget.user.type == User.USER_TYPE_ADMIN){
						admin_panel.visible = true;
					}
				}

				drawerItems.add(header);
				drawerItems.add(home);
				drawerItems.add(news);
				drawerItems.add(community);
				drawerItems.add(competition);
				drawerItems.add(profil);
				drawerItems.add(admin_panel);
				drawerItems.add(settings);
				drawerItems.add(about);
				drawerItems.add(login);
				drawerItems.add(logout);
			});
		});
	}

	onDrawerItemSelected(int id){
		bool pushReplacement = false, transition = true;
		MaterialPageRoute materialPageRoute;
		switch(id){
			case 1: //click on home
				transition = false;
				Navigator.pushReplacement(
						context,
						NoAnimationMaterialPageRoute(
								builder: (BuildContext context){
									return HomePage();
								}
						));
				break;
			case 2: //click on news
				materialPageRoute = MaterialPageRoute(
						builder: (BuildContext context){
							return NewsList(CompetitionItem.COMPETITION_TYPE);
						}
				);
				break;
			case 3: //click on community
				materialPageRoute = MaterialPageRoute(
						builder: (BuildContext context){
							return Community();
						}
				);
				break;
			case 5: //click on profil
				materialPageRoute = MaterialPageRoute
					(
						builder: (BuildContext context){
							return UserProfile(this.widget.user,this.widget.user);
						}
				);
				break;
			case 6: //click on admin panel
				transition = false;
				Navigator.push(
						context,
						MaterialPageRoute
							(
								builder: (BuildContext context){
									return AdminPanelPage();
								}
						));
				break;
			case 7: //click on settings
				materialPageRoute = MaterialPageRoute
							(
								builder: (BuildContext context){
									return Settings();
								}
						);
				break;
			case 8: //click on about
				materialPageRoute = MaterialPageRoute
						(
								builder: (BuildContext context){
									return AboutScreen();
								},
								fullscreenDialog: true
						);
				break;
			case 9: //click on login
				transition = false;
				Navigator.pushReplacement(
						context,
						MaterialPageRoute
							(
								builder: (BuildContext context){
									return Login();
								}
						));
				break;
			case 9: //click on logout
				transition = false;
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
		if(transition) {
			PageTransition(context, materialPageRoute, pushReplacement)
					.checkForRateAndShareSuggestion();
		}
	}

	//init competion list
	Future<List<Widget>> initCompetitions() async{

		List<CompetitionItem> competitions = await CompetitionItem.getFeaturedCompetitions();

		List competitionDrawerItems = [];
		for(int index=0; index<2; index++) {
			DrawerItem drawer = new DrawerItem(index, competitions[index].title, DrawerType.item);
			competitionDrawerItems.add(drawer);
		}
		DrawerItem drawerMore = new DrawerItem(2, MyLocalizations.instanceLocalization['more'], DrawerType.item);
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
								MaterialPageRoute materialPageRoute = MaterialPageRoute(
										builder: (BuildContext context){
											return CompetitionPage(competitions[item.id]);
										}
								);
							  PageTransition(context, materialPageRoute, false).checkForRateAndShareSuggestion();
							  break;
							case 2://more
								Navigator.push(
											context,
											MaterialPageRoute(
													builder: (BuildContext context){
														return CompetitionList();
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