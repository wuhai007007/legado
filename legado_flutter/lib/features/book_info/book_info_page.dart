import 'package:flutter/material.dart';
import '../../core/models/search_book.dart';
import '../../core/models/book.dart';
import '../../core/models/book_chapter.dart';
import '../../core/database/daos/book_dao.dart';
import '../../core/database/daos/book_chapter_dao.dart';
import '../../core/services/source/book_source_service.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/models/book_source.dart';
import '../../theme/app_theme.dart';
import '../reader/reader_page.dart';

class BookInfoPage extends StatefulWidget {
  final SearchBook? searchBook;
  final Book? book;
  const BookInfoPage({super.key, this.searchBook, this.book});
  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  final _dao = BookDao();
  final _chapterDao = BookChapterDao();
  final _sourceDao = BookSourceDao();
  bool _loading = true;
  bool _inShelf = false;
  Book? _book;
  List<BookChapter> _chapters = [];
  String _name = '', _author = '', _intro = '', _kind = '';
  String _bookUrl = '';
  int _loadedChapters = 0;

  @override
  void initState() { super.initState(); _init(); }

  Future<void> _init() async {
    _bookUrl = widget.searchBook?.bookUrl ?? widget.book?.bookUrl ?? '';
    _book = await _dao.getByUrl(_bookUrl);
    _inShelf = _book != null;
    _name = widget.searchBook?.name ?? widget.book?.name ?? '';
    _author = widget.searchBook?.author ?? widget.book?.author ?? '';

    final origin = widget.searchBook?.origin ?? widget.book?.origin ?? '';
    if (origin.isNotEmpty && origin != 'local') {
      final source = await _sourceDao.getByUrl(origin);
      if (source != null) {
        final svc = BookSourceService(source);
        final info = await svc.getBookInfo(_bookUrl);
        if (info.isNotEmpty) {
          if (info['name'] != null && (info['name'] as String).isNotEmpty) _name = info['name'] as String;
          if (info['author'] != null) _author = info['author'] as String;
          _intro = info['intro'] as String? ?? '';
          _kind = info['kind'] as String? ?? '';
          _chapters = await svc.getChapterList(info['tocUrl'] as String? ?? _bookUrl);
          _loadedChapters = _chapters.length;
        }
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _addToShelf() async {
    if (_book != null) return;
    final origin = widget.searchBook?.origin ?? widget.book?.origin ?? 'local';
    final originName = widget.searchBook?.originName ?? widget.book?.originName ?? '';
    final book = Book(bookUrl: _bookUrl, name: _name, author: _author, origin: origin, originName: originName, intro: _intro, kind: _kind);
    await _dao.insert(book);
    if (_chapters.isNotEmpty) {
      await _chapterDao.bulkInsert(_chapters.map((ch) => BookChapter(bookUrl: _bookUrl, url: ch.url, title: ch.title, index: ch.index, tag: ch.tag)).toList());
      book.totalChapterNum = _chapters.length;
      await _dao.update(book);
    }
    setState(() { _inShelf = true; _book = book; });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('《》已加入书架')));
  }

  void _openReader() {
    if (_book == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderPage(book: _book!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_name, overflow: TextOverflow.ellipsis)),
      body: _loading ? const Center(child: CircularProgressIndicator())
      : ListView(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 100, height: 140, decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Center(child: Icon(Icons.book, size: 48, color: AppTheme.primaryColor))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_author.isNotEmpty) Text('作者: ' + _author, style: TextStyle(color: Colors.grey[600])),
            if (_loadedChapters > 0) Text('共 ' + _loadedChapters.toString() + ' 章', style: const TextStyle(fontSize: 13)),
          ])),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [
          Expanded(child: FilledButton.icon(onPressed: _inShelf ? _openReader : _addToShelf,
            icon: Icon(_inShelf ? Icons.menu_book : Icons.add), label: Text(_inShelf ? '开始阅读' : '加入书架'))),
        ])),
        if (_intro.isNotEmpty) Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('简介', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8), Text(_intro, style: TextStyle(color: Colors.grey[700], height: 1.5)),
        ])),
        if (_chapters.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 4), child: Text('目录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ..._chapters.take(100).map((ch) => ListTile(dense: true, title: Text(ch.title, style: const TextStyle(fontSize: 13)), trailing: const Icon(Icons.chevron_right, size: 16), onTap: () {})),
          if (_chapters.length > 100) const Padding(padding: EdgeInsets.all(8), child: Center(child: Text('...更多章节请在阅读器中查看'))),
        ],
      ]),
    );
  }
}
