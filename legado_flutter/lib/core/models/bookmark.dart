class Bookmark {
  int? id;
  String bookName;
  String bookAuthor;
  String? bookUrl;
  int? chapterIndex;
  String? chapterName;
  int? chapterPos;
  String? content;
  int? createTime;

  Bookmark({this.id, this.bookName = '', this.bookAuthor = '', this.bookUrl, this.chapterIndex, this.chapterName, this.chapterPos, this.content, this.createTime});

  factory Bookmark.fromMap(Map<String, dynamic> map) => Bookmark(
    id: map['id'] as int?, bookName: (map['bookName'] ?? '') as String,
    bookAuthor: (map['bookAuthor'] ?? '') as String, bookUrl: map['bookUrl']?.toString(),
    chapterIndex: map['chapterIndex'] as int?, chapterName: map['chapterName']?.toString(),
    chapterPos: map['chapterPos'] as int?, content: map['content']?.toString(),
    createTime: map['createTime'] as int?,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id, 'bookName': bookName, 'bookAuthor': bookAuthor,
    'bookUrl': bookUrl, 'chapterIndex': chapterIndex, 'chapterName': chapterName,
    'chapterPos': chapterPos, 'content': content, 'createTime': createTime ?? DateTime.now().millisecondsSinceEpoch,
  };
}
