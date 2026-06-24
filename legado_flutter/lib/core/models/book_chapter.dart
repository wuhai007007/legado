class BookChapter {
  final String bookUrl;
  final String url;
  String title;
  int index;
  String? tag;
  int totalContentSize;

  BookChapter({
    required this.bookUrl,
    required this.url,
    this.title = "",
    this.index = 0,
    this.tag,
    this.totalContentSize = 0,
  });

  factory BookChapter.fromMap(Map<String, dynamic> map) => BookChapter(
    bookUrl: map['bookUrl'] as String? ?? '',
    url: map['url'] as String? ?? '',
    title: map['title'] as String? ?? '',
    index: map['index'] as int? ?? 0,
    tag: map['tag'] as String?,
    totalContentSize: map['totalContentSize'] as int? ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'bookUrl': bookUrl, 'url': url, 'title': title,
    'index': index, 'tag': tag, 'totalContentSize': totalContentSize,
  };
}
