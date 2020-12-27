import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/banner_model.dart';
import 'package:wanandroid_flutter2/model/home_article_model.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/page/web_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  SwiperController _swiperController = SwiperController();
  var logger = Logger();
  List<BannerData> _bannerData = List();
  List<Article> _articleData = List();
  bool _isLoadData = false;
  bool _isShowToTopBtn = false;
  int _articlePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: _mainContent,
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 0.5,
            color: Colors.black12,
          );
        },
        itemCount: _articleData.length + 1,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
      ),
      floatingActionButton: !_isShowToTopBtn
          ? null
          : FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              child: Icon(Icons.arrow_upward),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getBannerData();
    _getArticleData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoadData) {
          _isLoadData = true;
          _getArticleData();
        }
      }
      if (_scrollController.offset < 200 && _isShowToTopBtn) {
        setState(() {
          _isShowToTopBtn = false;
        });
      } else if (_scrollController.offset >= 200 && !_isShowToTopBtn) {
        setState(() {
          _isShowToTopBtn = true;
        });
      }
    });
  }

  Widget _mainContent(BuildContext context, int index) {
    if (index == 0) {
      return getBannerWidget();
    }
    if (index < _articleData.length - 1) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return WebDetailPage(
              title: _articleData[index].title,
              url: _articleData[index].link,
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
                    _articleData[index - 1].title,
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
                    _articleData[index - 1].author,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                      child: Text(
                    _articleData[index - 1].niceDate,
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
                    _articleData[index - 1].superChapterName,
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
  }

  Widget getBannerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        itemCount: _bannerData.length,
        loop: true,
        autoplay: true,
        autoplayDelay: 3000,
        autoplayDisableOnInteraction: false,
        duration: 600,
        controller: _swiperController,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9)),
        viewportFraction: 0.85,
        scale: 0.9,
        onTap: (index) {
          logger.d("swiper on tap = " + index.toString());
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(_bannerData[index].imagePath),
                    fit: BoxFit.fill)),
          );
        },
      ),
    );
  }

  _getArticleData() async {
    ApiService().getHomeArticle((HomeArticleModel _homeModel) {
      setState(() {
        _isLoadData = false;
        if (_articlePage == 0) {
          _articleData.clear();
        }
        if (_homeModel.data.datas.length == 0) {
          Fluttertoast.showToast(msg: "no more data");
        } else {
          _articleData.addAll(_homeModel.data.datas);
          _articlePage += 1;
          logger.d("current page = $_articlePage");
        }
        logger.d("_getArticleData length = ${_homeModel.data.datas.length}");
      });
    }, (DioError error) {
      logger.e("error = $error");
      setState(() {
        _isLoadData = false;
      });
    }, _articlePage);
  }

  _getBannerData() async {
    ApiService().getBanner((BannerModel _bannerModel) {
      setState(() {
        _bannerData.clear();
        _bannerData.addAll(_bannerModel.data);
      });
    }, (DioError error) {
      logger.e("error = $error");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _swiperController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
