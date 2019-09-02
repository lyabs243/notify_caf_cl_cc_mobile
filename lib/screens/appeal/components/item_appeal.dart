import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'appeal_dialog.dart';
import '.././../../models/appeal_item.dart';
import '../../../components/empty_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../models/user.dart';

class ItemAppeal extends StatefulWidget{

  Map localization;

  ItemAppeal(this.localization);

  @override
  _ItemAppealState createState() {
    // TODO: implement createState
    return new _ItemAppealState();
  }

}

class _ItemAppealState extends State<ItemAppeal>{

  Map localization;
  List<AppealItem> items;
  bool isPageLoading = true;
  bool isPageRefresh = false;
  User currentUser;

  int page = 1;

  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localization = this.widget.localization;
    _refreshController = RefreshController(initialRefresh: false);
    User.getInstance().then((_user){
      setState(() {
        currentUser = _user;
      });
    });
    items = new List<AppealItem>();
    initItems();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: (items.length>0)? true : false,
      header: (WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).primaryColor,
      )),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus mode){
          Widget body ;
          if(mode==LoadStatus.loading){
            body =  CircularProgressIndicator();
          }
          else{
            body = Container();
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (isPageLoading)?
      Center(
        child: CircularProgressIndicator(),
      ):
      (isPageRefresh)?
      Center():
      (items.length<=0)?
      EmptyData(localization):
      ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context,i){
            return InkWell(
              child: Card(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RichText(
                            text: new TextSpan(
                              text: items[i].full_name,
                              style: new TextStyle(
                                  color: Theme.of(context).textTheme.body1.color,fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {

                                },
                            ),
                          ),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(left: 5.0),
                            decoration: BoxDecoration(
                                color: (items[i].is_policie_violate)? Colors.green : Colors.red,
                                shape: BoxShape.circle
                            ),
                          ),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(left: 5.0),
                            decoration: BoxDecoration(
                                color: (items[i].is_policie_respect_after_activation)? Colors.green : Colors.red,
                                shape: BoxShape.circle
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 5.0),),
                      Text(
                        items[i].appeal_description,
                        maxLines: 3,
                      )
                    ],
                  ),
                  margin: EdgeInsets.all(2.0),
                  padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                ),
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context){
                      return new AppealDialog(this.localization,items[i],currentUser);
                    },
                    fullscreenDialog: true
                )).then((appeal){
                  if(appeal != null){
                    //si on approuve ou o desactive l appel on le supprime de la liste
                    if(appeal.approve || !appeal.active){
                      setState(() {
                        items.removeAt(i);
                      });
                    }
                  }
                });
              },
            );
          })),
    );
  }

  void _onRefresh() async{
    isPageRefresh = true;
    await initItems();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  Future initItems() async{
    page = 1;
    List<AppealItem> appeals = await AppealItem.getAppeals(page: page);
    if(appeals.length > 0){
      setState(() {
        items.clear();
        items = appeals;
        isPageRefresh = false;
        isPageLoading = false;
        page++;
      });
    }
  }

  Future addItems() async{
    List<AppealItem> appeals = await AppealItem.getAppeals(page: page);
    if(appeals.length > 0){
      setState(() {
        items.addAll(appeals);
        page++;
      });
    }
    _refreshController.loadComplete();
  }
}