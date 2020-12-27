import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wanandroid_flutter2/model/TreeModel.dart';
import 'package:wanandroid_flutter2/net/api_service.dart';
import 'package:wanandroid_flutter2/page/tree_detail_page.dart';
import 'package:wanandroid_flutter2/utils/utils.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> with AutomaticKeepAliveClientMixin{
  var logger = Logger();
  List<TreeData> treeData = List();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: _TreeContent,
      separatorBuilder: (BuildContext context, int index) {
        return Container();
      },
      itemCount: treeData.length,
      physics: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  void initState() {
    super.initState();
    getTreeData();
  }

  getTreeData() async {
    ApiService().getTreeData((TreeModel _treeModel) {
      setState(() {
        logger.d(_treeModel.data.length);
        treeData.clear();
        treeData.addAll(_treeModel.data);
      });
    }, (DioError error) {
      logger.e("getTreeData error=$error");
    });
  }

  Widget _TreeContent(BuildContext context, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    treeData[index].name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Wrap(
                      children: _buildTreeItem(treeData[index].children),
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return TreeDetailPage(ValueKey(treeData[index]));
        }));
      },
    );

  }

  List<Widget> _buildTreeItem(List<TreeChildren> child){
    List<Widget> widgets = List();
    for(int i = 0 ; i < child.length ;i++){
      if(i < 10){
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Chip(label: Text(child[i].name),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,backgroundColor: Utils.getChipBgColor(child[i].name),),
        ));
      }
    }
    return widgets;
  }

  @override
  bool get wantKeepAlive => true;
}
