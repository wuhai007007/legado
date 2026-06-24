class SearchRule implements BookListRule {
  String? checkKeyWord;
  @override String? bookList;
  @override String? name;
  @override String? author;
  @override String? intro;
  @override String? kind;
  @override String? lastChapter;
  @override String? updateTime;
  @override String? bookUrl;
  @override String? coverUrl;
  @override String? wordCount;

  SearchRule({
    this.checkKeyWord,
    this.bookList,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.bookUrl,
    this.coverUrl,
    this.wordCount,
  });

  factory SearchRule.fromJson(Map<String, dynamic> json) {
    return SearchRule(
      checkKeyWord: json['checkKeyWord'],
      bookList: json['bookList'],
      name: json['name'], author: json['author'],
      intro: json['intro'], kind: json['kind'],
      lastChapter: json['lastChapter'], updateTime: json['updateTime'],
      bookUrl: json['bookUrl'], coverUrl: json['coverUrl'],
      wordCount: json['wordCount'],
    );
  }
  Map<String, dynamic> toJson() => {if (bookList != null) 'bookList': bookList, if (name != null) 'name': name, if (author != null) 'author': author, if (intro != null) 'intro': intro, if (kind != null) 'kind': kind, if (lastChapter != null) 'lastChapter': lastChapter, if (updateTime != null) 'updateTime': updateTime, if (bookUrl != null) 'bookUrl': bookUrl, if (coverUrl != null) 'coverUrl': coverUrl, if (wordCount != null) 'wordCount': wordCount, if (checkKeyWord != null) 'checkKeyWord': checkKeyWord};
}

class ExploreRule implements BookListRule {
  @override String? bookList;
  @override String? name;
  @override String? author;
  @override String? intro;
  @override String? kind;
  @override String? lastChapter;
  @override String? updateTime;
  @override String? bookUrl;
  @override String? coverUrl;
  @override String? wordCount;

  ExploreRule({this.bookList, this.name, this.author, this.intro, this.kind, this.lastChapter, this.updateTime, this.bookUrl, this.coverUrl, this.wordCount});

  factory ExploreRule.fromJson(Map<String, dynamic> json) => ExploreRule(bookList: json['bookList'], name: json['name'], author: json['author'], intro: json['intro'], kind: json['kind'], lastChapter: json['lastChapter'], updateTime: json['updateTime'], bookUrl: json['bookUrl'], coverUrl: json['coverUrl'], wordCount: json['wordCount']);
  Map<String, dynamic> toJson() => {if (bookList != null) 'bookList': bookList, if (name != null) 'name': name, if (author != null) 'author': author, if (intro != null) 'intro': intro, if (kind != null) 'kind': kind, if (lastChapter != null) 'lastChapter': lastChapter, if (updateTime != null) 'updateTime': updateTime, if (bookUrl != null) 'bookUrl': bookUrl, if (coverUrl != null) 'coverUrl': coverUrl, if (wordCount != null) 'wordCount': wordCount};
}

class TocRule {
  String? preUpdateJs;
  String? chapterList;
  String? chapterName;
  String? chapterUrl;
  String? formatJs;
  String? isVolume;
  String? isVip;
  String? isPay;
  String? updateTime;
  String? nextTocUrl;

  TocRule({this.preUpdateJs, this.chapterList, this.chapterName, this.chapterUrl, this.formatJs, this.isVolume, this.isVip, this.isPay, this.updateTime, this.nextTocUrl});

  factory TocRule.fromJson(Map<String, dynamic> json) => TocRule(preUpdateJs: json['preUpdateJs'], chapterList: json['chapterList'], chapterName: json['chapterName'], chapterUrl: json['chapterUrl'], formatJs: json['formatJs'], isVolume: json['isVolume'], isVip: json['isVip'], isPay: json['isPay'], updateTime: json['updateTime'], nextTocUrl: json['nextTocUrl']);
  Map<String, dynamic> toJson() => {if (preUpdateJs != null) 'preUpdateJs': preUpdateJs, if (chapterList != null) 'chapterList': chapterList, if (chapterName != null) 'chapterName': chapterName, if (chapterUrl != null) 'chapterUrl': chapterUrl, if (formatJs != null) 'formatJs': formatJs, if (isVolume != null) 'isVolume': isVolume, if (isVip != null) 'isVip': isVip, if (isPay != null) 'isPay': isPay, if (updateTime != null) 'updateTime': updateTime, if (nextTocUrl != null) 'nextTocUrl': nextTocUrl};
}

class ContentRule {
  String? content;
  String? title;
  String? nextContentUrl;
  String? webJs;
  String? sourceRegex;
  String? replaceRegex;
  String? imageStyle;
  String? imageDecode;
  String? payAction;

  ContentRule({this.content, this.title, this.nextContentUrl, this.webJs, this.sourceRegex, this.replaceRegex, this.imageStyle, this.imageDecode, this.payAction});

  factory ContentRule.fromJson(Map<String, dynamic> json) => ContentRule(content: json['content'], title: json['title'], nextContentUrl: json['nextContentUrl'], webJs: json['webJs'], sourceRegex: json['sourceRegex'], replaceRegex: json['replaceRegex'], imageStyle: json['imageStyle'], imageDecode: json['imageDecode'], payAction: json['payAction']);
  Map<String, dynamic> toJson() => {if (content != null) 'content': content, if (title != null) 'title': title, if (nextContentUrl != null) 'nextContentUrl': nextContentUrl, if (webJs != null) 'webJs': webJs, if (sourceRegex != null) 'sourceRegex': sourceRegex, if (replaceRegex != null) 'replaceRegex': replaceRegex, if (imageStyle != null) 'imageStyle': imageStyle, if (imageDecode != null) 'imageDecode': imageDecode, if (payAction != null) 'payAction': payAction};
}

class BookListRule {
  String? bookList;
  String? name;
  String? author;
  String? intro;
  String? kind;
  String? lastChapter;
  String? updateTime;
  String? bookUrl;
  String? coverUrl;
  String? wordCount;
}
