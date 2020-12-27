import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/project_detail_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/page/web_detail_page.dart';
import 'package:wanandroid_flutter2/res/colors.dart';

class ProjectItem extends StatefulWidget {
  final int id;

  ProjectItem(this.id);

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem>
    with AutomaticKeepAliveClientMixin {
  List<ProjectDetailData> _projectData = List();
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  var logger = Logger();
  bool _isLoadData = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return _buildContent(context, index);
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 0.5,
              color: Colors.black26,
            );
          },
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _projectData.length),
    );
  }

  Widget _buildContent(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return WebDetailPage(
            title: _projectData[index].title,
            url: _projectData[index].link,
          );
        }));
      },
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 16, 8, 8),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _projectData[index].title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _projectData[index].desc,
                        maxLines: 3,
                        style: TextStyle(
                            color: WColors.secondaryText, fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _projectData[index].author,
                              style: TextStyle(color: Colors.grey),
                            ),
                            flex: 1,
                          ),
                          Text(_projectData[index].niceDate),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Image.network(
                _projectData[index].envelopePic,
                width: 80,
                height: 140,
                fit: BoxFit.fill,
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProjectData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoadData) {
          _isLoadData = true;
          getProjectData();
        }
      }
    });
  }

  getProjectData() async {
    ApiService().getProjectDetailData((ProjectDetailModel _model) {
      setState(() {
        _isLoadData = false;
        logger.d(_model.data.datas.length);
        if (currentPage == 0) {
          _projectData.clear();
        }
        if (_model.data.datas.length == 0) {
          Fluttertoast.showToast(msg: "no more data");
        } else {
          _projectData.addAll(_model.data.datas);
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
