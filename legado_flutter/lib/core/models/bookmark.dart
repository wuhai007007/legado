class Bookmark {
  int? id;
  String bookName;
  String bookAuthor;
  String? bookUrl;
  String? chapterIndex;
  String? chapterName;
  int? chapterPos;
  String? content;
  int? createTime;

  Bookmark({this.id, required this.bookName, required this.bookAuthor, this.bookUrl, this.chapterIndex, this.chapterName, this.chapterPos, this.content, this.createTime});

  factory Bookmark.fromMap(Map<String, dynamic> map) => Bookmark(
    id: map['id'] as int?, bookName: map['bookName'] ?? '', bookAuthor: map['bookAuthor'] ?? '',
    bookUrl: map['bookUrl'], chapterIndex: map['chapterIndex'], chapterName: map['chapterName'],
    chapterPos: map['chapterPos'], content: map['content'], createTime: map['createTime'],
  );

  Map<String, dynamic> toMap() => {'bookName': bookName, 'bookAuthor': bookAuthor, 'bookUrl': bookUrl, 'chapterIndex': chapterIndex, 'chapterName': chapterName, 'chapterPos': chapterPos, 'content': content, 'createTime': createTime};
}
