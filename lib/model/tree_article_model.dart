class TreeArticleModel {
  TreeDetailArticle data;
  int errorCode;
  String errorMsg;

  TreeArticleModel({this.data, this.errorCode, this.errorMsg});

  TreeArticleModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new TreeDetailArticle.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class TreeDetailArticle {
  int curPage;
  List<TreeDetailArticleData> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  TreeDetailArticle(
      {this.curPage,
        this.datas,
        this.offset,
        this.over,
        this.pageCount,
        this.size,
        this.total});

  TreeDetailArticle.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'];
    if (json['datas'] != null) {
      datas = new List<TreeDetailArticleData>();
      json['datas'].forEach((v) {
        datas.add(new TreeDetailArticleData.fromJson(v));
      });
    }
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curPage'] = this.curPage;
    if (this.datas != null) {
      data['datas'] = this.datas.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['over'] = this.over;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}

class TreeDetailArticleData {
  String apkLink;
  int audit;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String descMd;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int realSuperChapterId;
  int selfVisible;
  int shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  TreeDetailArticleData(
      {this.apkLink,
        this.audit,
        this.author,
        this.canEdit,
        this.chapterId,
        this.chapterName,
        this.collect,
        this.courseId,
        this.desc,
        this.descMd,
        this.envelopePic,
        this.fresh,
        this.id,
        this.link,
        this.niceDate,
        this.niceShareDate,
        this.origin,
        this.prefix,
        this.projectLink,
        this.publishTime,
        this.realSuperChapterId,
        this.selfVisible,
        this.shareDate,
        this.shareUser,
        this.superChapterId,
        this.superChapterName,
        this.title,
        this.type,
        this.userId,
        this.visible,
        this.zan});

  TreeDetailArticleData.fromJson(Map<String, dynamic> json) {
    apkLink = json['apkLink'];
    audit = json['audit'];
    author = json['author'];
    canEdit = json['canEdit'];
    chapterId = json['chapterId'];
    chapterName = json['chapterName'];
    collect = json['collect'];
    courseId = json['courseId'];
    desc = json['desc'];
    descMd = json['descMd'];
    envelopePic = json['envelopePic'];
    fresh = json['fresh'];
    id = json['id'];
    link = json['link'];
    niceDate = json['niceDate'];
    niceShareDate = json['niceShareDate'];
    origin = json['origin'];
    prefix = json['prefix'];
    projectLink = json['projectLink'];
    publishTime = json['publishTime'];
    realSuperChapterId = json['realSuperChapterId'];
    selfVisible = json['selfVisible'];
    shareDate = json['shareDate'];
    shareUser = json['shareUser'];
    superChapterId = json['superChapterId'];
    superChapterName = json['superChapterName'];
    title = json['title'];
    type = json['type'];
    userId = json['userId'];
    visible = json['visible'];
    zan = json['zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apkLink'] = this.apkLink;
    data['audit'] = this.audit;
    data['author'] = this.author;
    data['canEdit'] = this.canEdit;
    data['chapterId'] = this.chapterId;
    data['chapterName'] = this.chapterName;
    data['collect'] = this.collect;
    data['courseId'] = this.courseId;
    data['desc'] = this.desc;
    data['descMd'] = this.descMd;
    data['envelopePic'] = this.envelopePic;
    data['fresh'] = this.fresh;
    data['id'] = this.id;
    data['link'] = this.link;
    data['niceDate'] = this.niceDate;
    data['niceShareDate'] = this.niceShareDate;
    data['origin'] = this.origin;
    data['prefix'] = this.prefix;
    data['projectLink'] = this.projectLink;
    data['publishTime'] = this.publishTime;
    data['realSuperChapterId'] = this.realSuperChapterId;
    data['selfVisible'] = this.selfVisible;
    data['shareDate'] = this.shareDate;
    data['shareUser'] = this.shareUser;
    data['superChapterId'] = this.superChapterId;
    data['superChapterName'] = this.superChapterName;
    data['title'] = this.title;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    data['zan'] = this.zan;
    return data;
  }
}
