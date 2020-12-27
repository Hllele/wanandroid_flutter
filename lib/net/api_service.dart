import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/TreeModel.dart';
import 'package:wanandroid_flutter2/model/banner_model.dart';
import 'package:wanandroid_flutter2/model/home_article_model.dart';
import 'package:wanandroid_flutter2/model/navi_model.dart';
import 'package:wanandroid_flutter2/model/project_detail_model.dart';
import 'package:wanandroid_flutter2/model/project_model.dart';
import 'package:wanandroid_flutter2/model/tree_article_model.dart';
import 'package:wanandroid_flutter2/model/user.dart';
import 'package:wanandroid_flutter2/net/api.dart';
import 'package:wanandroid_flutter2/net/dio_manager.dart';

class ApiService {

  /// 首页banner
  void getBanner(Function successBack, Function errorBack) async {
    DioManager.singleton.dio
        .get(Api.HOME_BANNER, options: _getOptions())
        .then((response) {
      successBack(BannerModel.fromJson(response.data));
    }).catchError((e) {
      errorBack(e);
    });
  }

  /// 首页文章
  void getHomeArticle(Function callback, Function errorback, int _page) async {
    DioManager.singleton.dio
        .get(Api.HOME_ARTICLE_LIST + "$_page/json", options: _getOptions())
        .then((response) {
      callback(HomeArticleModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 体系
  void getTreeData(Function callback, Function errorback) async {
    DioManager.singleton.dio
        .get(Api.SYSTEM_TREE, options: _getOptions())
        .then((response) {
      callback(TreeModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  ///体系对应文章
  void getTreeDetail(Function callback, Function errorback,int cid,int page) async{
    DioManager.singleton.dio
        .get(Api.SYSTEM_TREE_CONTENT +"$page/json?cid=$cid", options: _getOptions())
        .then((response) {
      callback(TreeArticleModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  ///导航
  void getNaviData(Function callback, Function errorback) async{
    DioManager.singleton.dio
        .get(Api.NAVI_LIST, options: _getOptions())
        .then((response) {
      callback(NaviModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  ///项目
  void getProjectData(Function callback, Function errorback) async{
    DioManager.singleton.dio
        .get(Api.PROJECT_TREE, options: _getOptions())
        .then((response) {
      callback(ProjectModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  ///项目数据
  void getProjectDetailData(Function callback, Function errorback,int cid,int page) async{
    DioManager.singleton.dio
        .get(Api.PROJECT_LIST +"$page/json?cid=$cid", options: _getOptions())
        .then((response) {
      callback(ProjectDetailModel.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  Options _getOptions() {
    Map<String, String> map = Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}
