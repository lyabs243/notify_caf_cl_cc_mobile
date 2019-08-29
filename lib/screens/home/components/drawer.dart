import 'package:flutter/material.dart';
import '../../../models/drawer_item.dart';
import '../../../models/user.dart';
import '../../../screens/login/login.dart';
import '../../../screens/user_profile/user_profile.dart';
import '../../../screens/appeal/appeal_page.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drawerItems = new List<DrawerItem>();
    initDrawerItems();
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
    DrawerItem profil = new DrawerItem(1, this.widget.localization['profil'], DrawerType.item,iconPath: 'assets/icons/profile.png');
    DrawerItem appeal = new DrawerItem(2, this.widget.localization['subscriber_appeal'], DrawerType.item,iconPath: 'assets/icons/logout.png',visible: false);
    DrawerItem login = new DrawerItem(3, this.widget.localization['login'], DrawerType.item,iconPath: 'assets/icons/login.png');
    DrawerItem logout = new DrawerItem(4, this.widget.localization['logout'], DrawerType.item,iconPath: 'assets/icons/logout.png');

    //set visibility
    if(this.widget.user.id_accout_type == User.NOT_CONNECTED_ACCOUNT_ID){
      profil.visible = false;
      logout.visible = false;
    }
    else{
      login.visible = false;
      if(this.widget.user.type == User.USER_TYPE_ADMIN){
        appeal.visible = true;
      }
    }

    drawerItems.add(header);
    drawerItems.add(profil);
    drawerItems.add(appeal);
    drawerItems.add(login);
    drawerItems.add(logout);
  }

  onDrawerItemSelected(int id){
    switch(id){
      case 1: //click on profil
        Navigator.push(
            context,
            MaterialPageRoute
              (
                builder: (BuildContext context){
                  return UserProfile(this.widget.user,this.widget.localization);
                }
            ));
        break;
      case 2: //click on appeal
        Navigator.push(
            context,
            MaterialPageRoute
              (
                builder: (BuildContext context){
                  return AppealPage(this.widget.localization);
                }
            ));
        break;
      case 3: //click on login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute
          (
              builder: (BuildContext context){
                return Login();
              }
          ));
        break;
      case 4: //click on logout
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

}