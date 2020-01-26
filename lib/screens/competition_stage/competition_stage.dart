import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'components/stage_tabview.dart';
import '../../components/empty_data.dart';
import '../../models/competition_item.dart';
import '../../models/competition_stage.dart' as stage;
import '../../models/constants.dart' as constant;

class CompetitionStage extends StatefulWidget{

  Map localization;
  CompetitionItem competitionItem;

  CompetitionStage(this.localization,this.competitionItem);

  @override
  _CompetitionStageState createState() {
    // TODO: implement createState
    return new _CompetitionStageState();
  }

}

class _CompetitionStageState extends State<CompetitionStage>{

  List<stage.CompetitionStage> competitionStages = [];
  List<Tab> tabs = [];

  List<Widget> tabViews = [];
  bool isLoading = true;

  AdmobBanner admobBanner;

  List<int> selectedGroups = [];
  List<int> selectedButtons = [];  //to know zhich button between (result,schedule and table) is selected

  initData() async {
    await Future.delayed(Duration.zero);
    initCompetitionStages();
  }

  @override
  void initState() {
    super.initState();
    Admob.initialize(constant.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    initData();
  }
  
  @override
  Widget build(BuildContext context) {

    return (isLoading || competitionStages.length <= 0)?
        Scaffold(
          appBar: AppBar(title: Text(this.widget.localization['stages']),),
          body: (isLoading)? Center(child: CircularProgressIndicator(),) : EmptyData(this.widget.localization),
        ):
    DefaultTabController(
      length: competitionStages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.localization['stages']),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0,color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal:16.0)
            ),
          ),
        ),
        body: TabBarView(children: tabViews),
        bottomSheet: (constant.canShowAds)?
        Container(
          width: MediaQuery.of(context).size.width,
          child: admobBanner,
        ): Container(),
      ),
    );
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  initCompetitionStages(){
    stage.CompetitionStage.getCompetitionStages(context, this.widget.competitionItem.id).then((result){
      setState(() {
        competitionStages.addAll(result);
        competitionStages.forEach((cmpStage){
          tabs.add(Tab(text: '${cmpStage.title}',));
          (cmpStage.groups != null && cmpStage.groups.length > 0)? selectedGroups.add(cmpStage.groups[0].id) : selectedGroups.add(0);
          selectedButtons.add(1);
        });
        initTabs(tabViews);
        isLoading = false;
      });
    });
  }
  
  initTabs(List<Widget> tabViews){
    for(int i=0;i< competitionStages.length;i++){
      tabViews.add(
        StageTabview(this.widget.localization, competitionStages[i], selectedGroups[i], selectedButtons[i]),
      );
    }
  }

}
