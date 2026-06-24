
class SearchBook {
  String name;
  String author;
  String? kind;
  String bookUrl;
  String origin;
  String originName;
  int type;
  String? wordCount;
  String? latestChapterTitle;
  String? coverUrl;
  String? intro;
  String tocUrl;
  int originOrder;
  String? variable;
  String? infoHtml;
  String? tocHtml;

  SearchBook({
    this.name = '',
    this.author = '',
    this.kind,
    this.bookUrl = '',
    this.origin = '',
    this.originName = '',
    this.type = 0,
    this.wordCount,
    this.latestChapterTitle,
    this.coverUrl,
    this.intro,
    this.tocUrl = '',
    this.originOrder = 0,
    this.variable,
  });
}
