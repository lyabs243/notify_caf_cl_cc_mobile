import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import '../../models/competition_item.dart';
import '../../components/curve_painter.dart';
import '../../components/empty_data.dart';
import '../competition/competition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CompetitionList extends StatefulWidget{

  CompetitionList();

  @override
  _CompetitionListState createState() {
    return new _CompetitionListState();
  }

}

class _CompetitionListState extends State<CompetitionList>{

  List<CompetitionItem> list = [];
  int page=1;
  bool isLoadPage = true;
  bool isPageRefresh = false;
  RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    initItems();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SmartRefresher(
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
                        MyLocalizations.instanceLocalization['all_competitions'],
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
            EmptyData():
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
                        child: Container(
                          height: 100.0,
                          margin: EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 10.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                (list[i].trophy_icon_url != null && list[i].trophy_icon_url.length > 0)?
                                ImageIcon(NetworkImage(list[i].trophy_icon_url),color: Theme.of(context).primaryColor,size: 50.0):
                                ImageIcon(AssetImage('assets/default_trophy.png'),color: Theme.of(context).primaryColor,size: 50.0),
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
                        ),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context){
                                return CompetitionPage(list[i]);
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
      ),
    );
  }

  void _onRefresh() async{
    setState(() {
      isLoadPage = true;
    });
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems() async{
    await Future.delayed(Duration.zero);
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