
class Book {
  String bookUrl;
  String tocUrl;
  String origin;
  String originName;
  String name;
  String author;
  String? kind;
  String? customTag;
  String? coverUrl;
  String? customCoverUrl;
  String? intro;
  String? customIntro;
  String? charset;
  int type;
  int group;
  String? latestChapterTitle;
  int latestChapterTime;
  int lastCheckTime;
  int lastCheckCount;
  int totalChapterNum;
  String? durChapterTitle;
  int durChapterIndex;
  int durChapterPos;
  int durChapterTime;
  String? wordCount;
  bool canUpdate;
  int order;
  int originOrder;
  String? variable;
  String? infoHtml;
  String? tocHtml;
  int syncTime;

  Book({
    this.bookUrl = '',
    this.tocUrl = '',
    this.origin = 'local',
    this.originName = '',
    this.name = '',
    this.author = '',
    this.kind,
    this.customTag,
    this.coverUrl,
    this.customCoverUrl,
    this.intro,
    this.customIntro,
    this.charset,
    this.type = 0,
    this.group = 0,
    this.latestChapterTitle,
    this.latestChapterTime = 0,
    this.lastCheckTime = 0,
    this.lastCheckCount = 0,
    this.totalChapterNum = 0,
    this.durChapterTitle,
    this.durChapterIndex = 0,
    this.durChapterPos = 0,
    this.durChapterTime = 0,
    this.wordCount,
    this.canUpdate = true,
    this.order = 0,
    this.originOrder = 0,
    this.variable,
    this.infoHtml,
    this.tocHtml,
    this.syncTime = 0,
  });

  factory Book.fromMap(Map<String, dynamic> map) => Book(
    bookUrl: (map['bookUrl'] ?? '') as String,
    tocUrl: (map['tocUrl'] ?? '') as String,
    origin: (map['origin'] ?? 'local') as String,
    originName: (map['originName'] ?? '') as String,
    name: (map['name'] ?? '') as String,
    author: (map['author'] ?? '') as String,
    kind: map['kind']?.toString(),
    customTag: map['customTag']?.toString(),
    coverUrl: map['coverUrl']?.toString(),
    customCoverUrl: map['customCoverUrl']?.toString(),
    intro: map['intro']?.toString(),
    customIntro: map['customIntro']?.toString(),
    charset: map['charset']?.toString(),
    type: (map['type'] as int?) ?? 0,
    group: (map['group'] as int?) ?? 0,
    latestChapterTitle: map['latestChapterTitle']?.toString(),
    latestChapterTime: (map['latestChapterTime'] as int?) ?? 0,
    lastCheckTime: (map['lastCheckTime'] as int?) ?? 0,
    lastCheckCount: (map['lastCheckCount'] as int?) ?? 0,
    totalChapterNum: (map['totalChapterNum'] as int?) ?? 0,
    durChapterTitle: map['durChapterTitle']?.toString(),
    durChapterIndex: (map['durChapterIndex'] as int?) ?? 0,
    durChapterPos: (map['durChapterPos'] as int?) ?? 0,
    durChapterTime: (map['durChapterTime'] as int?) ?? 0,
    wordCount: map['wordCount']?.toString(),
    canUpdate: (map['canUpdate'] as int?) == 1,
    order: (map['order'] as int?) ?? 0,
    originOrder: (map['originOrder'] as int?) ?? 0,
    variable: map['variable']?.toString(),
    infoHtml: map['infoHtml']?.toString(),
    tocHtml: map['tocHtml']?.toString(),
    syncTime: (map['syncTime'] as int?) ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'bookUrl': bookUrl, 'tocUrl': tocUrl, 'origin': origin,
    'originName': originName, 'name': name, 'author': author,
    'kind': kind, 'customTag': customTag, 'coverUrl': coverUrl,
    'customCoverUrl': customCoverUrl, 'intro': intro, 'customIntro': customIntro,
    'charset': charset, 'type': type, 'group': group,
    'latestChapterTitle': latestChapterTitle, 'latestChapterTime': latestChapterTime,
    'lastCheckTime': lastCheckTime, 'lastCheckCount': lastCheckCount,
    'totalChapterNum': totalChapterNum, 'durChapterTitle': durChapterTitle,
    'durChapterIndex': durChapterIndex, 'durChapterPos': durChapterPos,
    'durChapterTime': durChapterTime, 'wordCount': wordCount,
    'canUpdate': canUpdate ? 1 : 0, 'order': order, 'originOrder': originOrder,
    'variable': variable, 'syncTime': syncTime,
  };
}
