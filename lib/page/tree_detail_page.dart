import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/TreeModel.dart';
import 'package:wanandroid_flutter2/model/tree_article_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/widget/tree_article.dart';

class TreeDetailPage extends StatefulWidget {
  TreeData data;

  TreeDetailPage(ValueKey<TreeData> key) : super(key: key) {
    this.data = key.value;
  }

  @override
  _TreeDetailPageState createState() => _TreeDetailPageState();
}

class _TreeDetailPageState extends State<TreeDetailPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TreeData _data;
  int clickIndex = 0;
  var logger = Logger();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._data = widget.data;
    _tabController = TabController(length: _data.children.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(_data.name),
        centerTitle: true,
        bottom: TabBar(
          tabs: _buildTab(),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        children: _data.children.map((item) {
          return TreeArticle(item.id);
        }).toList(),
        controller: _tabController,
      ),
    );
  }

  List<Tab> _buildTab() {
    List<Tab> tabs = List();
    for (int i = 0; i < _data.children.length; i++) {
      tabs.add(Tab(
        text: _data.children[i].name,
      ));
    }
    return tabs;
  }

  @override
  bool get wantKeepAlive => true;
}
