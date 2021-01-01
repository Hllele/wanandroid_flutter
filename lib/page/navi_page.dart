import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/navi_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/page/web_detail_page.dart';
import 'package:wanandroid_flutter2/res/colors.dart';
import 'package:wanandroid_flutter2/utils/utils.dart';

class NaviPage extends StatefulWidget {
  @override
  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage>
    with AutomaticKeepAliveClientMixin {
  var logger = Logger();
  List<NaviData> naviData = List();
  List<NaviArticles> articleData = List();
  int leftIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _getLeft(index);
              },
              itemCount: naviData.length,
              physics: AlwaysScrollableScrollPhysics(),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: WColors.color_F9F9F9,
            alignment: Alignment.topLeft,
            child: _getRight(),
          ),
          flex: 5,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getNaviData();
  }

  Widget _getLeft(int index) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: leftIndex == index ? WColors.color_F9F9F9 : Colors.white,
            border: Border(
                left: BorderSide(
                    width: 5,
                    color: leftIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.white))),
        child: Text(
          naviData[index].name,
          style: TextStyle(
              color: leftIndex == index ? Colors.black : Colors.grey,
              fontSize: leftIndex == index ? 16 : 14),
        ),
      ),
      onTap: () {
        setState(() {
          leftIndex = index;
          articleData.clear();
          articleData.addAll(naviData[leftIndex].articles);
        });
      },
    );
  }

  Widget _getRight() {
    return Wrap(
      spacing: 10,
      runSpacing: 3,
      alignment: WrapAlignment.start,
      children: _buildRightItem(),
    );
  }

  List<Widget> _buildRightItem() {
    List<Widget> items = List();
    items.clear();
    for (int i = 0; i < articleData.length; i++) {
      items.add(GestureDetector(child: Chip(label: Text(articleData[i].title,style: TextStyle(color: Colors.white),),backgroundColor: Utils.getRandomColor(),),onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return WebDetailPage(
            title: articleData[i].title,
            url: articleData[i].link,
          );
        }));
      },));
    }
    return items;
  }

  getNaviData() async {
    ApiService().getNaviData((NaviModel _model) {
      setState(() {
        naviData.clear();
        naviData.addAll(_model.data);
        articleData.clear();
        articleData.addAll(naviData[leftIndex].articles);
      });
    }, (DioError error) {
      logger.e(error);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
