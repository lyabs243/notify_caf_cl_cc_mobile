

class DrawerItem{

  int id;
  String title;
  DrawerType drawerType;
  bool visible;

  DrawerItem(this.id,this.title,this.drawerType,{this.visible: true});

}

enum DrawerType{
  item,
  header
}