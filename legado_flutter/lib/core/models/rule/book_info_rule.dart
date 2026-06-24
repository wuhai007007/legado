class BookInfoRule {
  String? init;
  String? name;
  String? author;
  String? intro;
  String? kind;
  String? lastChapter;
  String? updateTime;
  String? coverUrl;
  String? tocUrl;
  String? wordCount;
  String? canReName;
  String? downloadUrls;

  BookInfoRule({
    this.init,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.coverUrl,
    this.tocUrl,
    this.wordCount,
    this.canReName,
    this.downloadUrls,
  });

  factory BookInfoRule.fromJson(Map<String, dynamic> json) {
    return BookInfoRule(
      init: json['init'],
      name: json['name'],
      author: json['author'],
      intro: json['intro'],
      kind: json['kind'],
      lastChapter: json['lastChapter'],
      updateTime: json['updateTime'],
      coverUrl: json['coverUrl'],
      tocUrl: json['tocUrl'],
      wordCount: json['wordCount'],
      canReName: json['canReName'],
      downloadUrls: json['downloadUrls'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (init != null) 'init': init,
    if (name != null) 'name': name,
    if (author != null) 'author': author,
    if (intro != null) 'intro': intro,
    if (kind != null) 'kind': kind,
    if (lastChapter != null) 'lastChapter': lastChapter,
    if (updateTime != null) 'updateTime': updateTime,
    if (coverUrl != null) 'coverUrl': coverUrl,
    if (tocUrl != null) 'tocUrl': tocUrl,
    if (wordCount != null) 'wordCount': wordCount,
    if (canReName != null) 'canReName': canReName,
    if (downloadUrls != null) 'downloadUrls': downloadUrls,
  };
}
