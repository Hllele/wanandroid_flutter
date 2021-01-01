import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/page/navi_page.dart';
import 'package:wanandroid_flutter2/page/project_page.dart';
import 'package:wanandroid_flutter2/page/tree_page.dart';
import 'package:wanandroid_flutter2/res/constant.dart';

import 'home_page.dart';

class TabNavigation extends StatefulWidget {
  @override
  _TabNavigationState createState() => _TabNavigationState();
}

class _TabNavigationState extends State<TabNavigation> {
  var logger = Logger();
  PageController _pageController = PageController();
  int _currentIndex = 0;
  var title = Constant.appName;
  var page = <Widget>[HomePage(), TreePage(), NaviPage(), ProjectPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: PageView(
        children: page,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      drawer: _buildDraw(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.filter_list,
              ),
              title: Text("体系")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.low_priority,
              ),
              title: Text("导航")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.apps,
              ),
              title: Text("项目")),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColorDark,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(
                  milliseconds: 300,
                ),
                curve: Curves.ease);
            _changeTitle(index);
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDraw() {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/icon_avatar_default.jpg'),
              ),
            ),
          ),
          Container(
            height: 300,
            color: Colors.amberAccent,
          )
        ],
      ),
    );
  }

  void _changeTitle(int index) {
    setState(() {
      switch (index) {
        case 0:
          title = Constant.appName;
          break;
        case 1:
          title = Constant.tree;
          break;
        case 2:
          title = Constant.navi;
          break;
        case 3:
          title = Constant.project;
          break;
      }
    });
  }
}
