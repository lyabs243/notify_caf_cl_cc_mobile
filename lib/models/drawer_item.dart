

class DrawerItem{

  int id;
  String title;
  DrawerType drawerType;
  bool visible;
  String iconPath;

  DrawerItem(this.id,this.title,this.drawerType,{this.visible: true,this.iconPath: 'assets/icons/empty.png'});

}

enum DrawerType{
  item,
  header
}