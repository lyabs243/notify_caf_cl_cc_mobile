import 'package:flutter/material.dart';
import '../../../../models/competition_item.dart';
import '../../../../components/curve_painter.dart';
import '../../../../components/empty_data.dart';
import '../../../competition/competition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentCompetitionList extends StatefulWidget{

  Map localization;

  FragmentCompetitionList(this.localization);

  @override
  _FragmentCompetitionListState createState() {
    // TODO: implement createState
    return new _FragmentCompetitionListState();
  }

}

class _FragmentCompetitionListState extends State<FragmentCompetitionList>{

  List<CompetitionItem> list = [];
  int page=1;
  bool isLoadPage = true;
  bool isPageRefresh = false;
  RefreshController refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(list.length == 0){
      initItems();
    }
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: false,
      enablePullDown: true,
      onRefresh: _onRefresh,
      header: (WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
        )),
      child: (isLoadPage)?
      Center(
        child: CircularProgressIndicator(),
      ):
      Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: CustomPaint(
              painter: CurvePainter(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment(0, -0.37),
                    width: MediaQuery.of(context).size.width/1.4,
                    child: Text(
                      this.widget.localization['all_competitions'],
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.1,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          (list.length <= 0)?
          EmptyData(this.widget.localization):
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              enablePullUp: (list.length > 0)? true : false,
              enablePullDown: false,
              onLoading: _onLoading,
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
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,i){
                    return InkWell(
                      child: Card(
                        elevation: 10.0,
                        child: Row(
                          children: <Widget>[
                            (list[i].trophy_icon_url != null && list[i].trophy_icon_url.length > 0)?
                            ImageIcon(NetworkImage(list[i].trophy_icon_url),color: Theme.of(context).primaryColor,size: 100.0):
                            ImageIcon(AssetImage('assets/default_trophy.png'),color: Theme.of(context).primaryColor,size: 100.0),
                            Container(
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Text(
                                list[i].title,
                                textScaleFactor: 1.3,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context){
                              return CompetitionPage(list[i],this.widget.localization);
                            })
                        );
                      },
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onRefresh() async{
    isPageRefresh = true;
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems(){
    page = 1;
    CompetitionItem.getCompetitions(context, page).then((result){
      if(result.length > 0){
        setState(() {
          page++;
          list.clear();
          list.addAll(result);
        });
      }
      setState(() {
        isLoadPage = false;
      });
    });
  }

  Future addItems() async{
    List<CompetitionItem> competItems = await CompetitionItem.getCompetitions(context,page);
    if(competItems.length > 0){
      setState(() {
        list.addAll(competItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

}