import 'package:flutter/material.dart';

class DrawerItem{

  int id;
  String title;
  DrawerType drawerType;
  bool visible;
  String iconPath;
  List<Widget> expandableItems;

  DrawerItem(this.id,this.title,this.drawerType,{this.visible: true,
    this.iconPath: 'assets/icons/empty.png',this.expandableItems: null});

}

enum DrawerType{
  item,
  header,
  expandable
}