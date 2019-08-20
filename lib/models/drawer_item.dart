

class DrawerItem{

  int id;
  String title;
  DrawerType drawerType;
  bool visible;
  String iconPath;

  DrawerItem(this.id,this.title,this.drawerType,this.iconPath,{this.visible: true});

}

enum DrawerType{
  item,
  header
}