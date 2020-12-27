import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/project_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/res/colors.dart';
import 'package:wanandroid_flutter2/widget/project_item.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with AutomaticKeepAliveClientMixin ,TickerProviderStateMixin{
  var logger = Logger();
  List<ProjectData> titleData = List();
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 14),
          unselectedLabelColor: WColors.color_666,
          unselectedLabelStyle: TextStyle(fontSize: 14),
          tabs: titleData.map((item){
            return Tab(text: item.name);
          }).toList(),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
      ),backgroundColor: Theme.of(context).primaryColor,
      body: TabBarView(
        children: titleData.map((item){
          return ProjectItem(item.id);
        }).toList(),
        controller: _tabController,
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    getProjectData();
  }

  getProjectData() async{
    ApiService().getProjectData((ProjectModel _model) {
      setState(() {
        logger.d(_model.data.length);
        titleData.clear();
        titleData.addAll(_model.data);
        _tabController = TabController(length: titleData.length, vsync: this);
      });
    }, (Error error) {
      logger.e("getProjectData error=$error");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
