import 'package:flutter/material.dart';
import '../../../models/drawer_item.dart';
import '../../../models/user.dart';

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
                },
                leading: ImageIcon(AssetImage('assets/icons/login.png'),color: Colors.white,),
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
    DrawerItem login = new DrawerItem(1, this.widget.localization['login'], DrawerType.item);
    DrawerItem logout = new DrawerItem(2, this.widget.localization['logout'], DrawerType.item);

    //set visibility
    if(this.widget.user.id_accout_type == User.NOT_CONNECTED_ACCOUNT_ID){
      logout.visible = false;
    }
    else{
      login.visible = false;
    }

    drawerItems.add(header);
    drawerItems.add(login);
    drawerItems.add(logout);
  }

}