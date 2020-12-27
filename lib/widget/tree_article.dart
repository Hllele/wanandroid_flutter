import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/tree_article_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/page/web_detail_page.dart';

class TreeArticle extends StatefulWidget {
  final int id;

  TreeArticle(this.id);

  @override
  _TreeArticleState createState() => _TreeArticleState();
}

class _TreeArticleState extends State<TreeArticle>
    with AutomaticKeepAliveClientMixin {
  List<TreeDetailArticleData> articleData = List();
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  var logger = Logger();
  bool _isLoadData = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return _buildContent(context, index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container();
        },
        itemCount: articleData.length,
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDetailData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoadData) {
          _isLoadData = true;
          getDetailData();
        }
      }
    });
  }

  getDetailData() async {
    ApiService().getTreeDetail((TreeArticleModel _model) {
      setState(() {
        _isLoadData = false;
        logger.d(_model.data.datas.length);
        if (currentPage == 0) {
          articleData.clear();
        }
        if (_model.data.datas.length == 0) {
          Fluttertoast.showToast(msg: "no more data");
        } else {
          articleData.addAll(_model.data.datas);
          currentPage += 1;
        }
      });
    }, (DioError error) {
      logger.e("getTreeData error=$error");
      setState(() {
        _isLoadData = false;
      });
    }, widget.id, currentPage);
  }

  Widget _buildContent(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return WebDetailPage(
            title: articleData[index].title,
            url: articleData[index].link,
          );
        }));
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  articleData[index].title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3D4E5F)),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text(
                  articleData[index].author,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                    child: Text(
                  articleData[index].niceDate,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 2, 16, 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  articleData[index].superChapterName,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
