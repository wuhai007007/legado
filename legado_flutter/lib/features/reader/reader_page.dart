import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/book.dart';
import '../../core/models/book_chapter.dart';
import '../../core/database/daos/book_chapter_dao.dart';
import '../../core/database/daos/book_dao.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/services/source/book_source_service.dart';
import '../../theme/app_theme.dart';
import '../../core/models/book_source.dart';

class ReaderPage extends StatefulWidget {
  final Book book;
  const ReaderPage({super.key, required this.book});
  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final _chapterDao = BookChapterDao();
  final _bookDao = BookDao();
  final _sourceDao = BookSourceDao();
  List<BookChapter> _chapters = [];
  int _currentIndex = 0;
  String _content = "";
  bool _showMenu = false;
  String _currentTheme = "yellow";
  double _fontSize = 18.0;
  bool _isLoadingContent = false;
  Book? _book;

  @override
  void initState() { super.initState(); _book = widget.book; _initReader(); }

  Future<void> _initReader() async {
    _currentIndex = _book!.durChapterIndex;
    _chapters = await _chapterDao.getByBookUrl(_book!.bookUrl);
    if (_chapters.isNotEmpty && _currentIndex < _chapters.length) {
      _loadContent(_currentIndex);
    }
  }

  Future<void> _loadContent(int index) async {
    if (index < 0 || index >= _chapters.length) return;
    setState(() { _currentIndex = index; _isLoadingContent = true; _content = ""; });
    try {
      final source = await _sourceDao.getByUrl(_book!.origin);
      if (source != null && _chapters[index].url.isNotEmpty) {
        final svc = BookSourceService(source);
        _content = await svc.getChapterContent(_chapters[index].url);
      }
    } catch (_) {}
    if (_content.isEmpty) {
      _content = "\u6b63\u6587\u52a0\u8f7d\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u7f51\u7edc\u6216\u4e66\u6e90\u914d\u7f6e";
    }
    _book!.durChapterIndex = index;
    _book!.durChapterTitle = _chapters[index].title;
    await _bookDao.update(_book!);
    setState(() => _isLoadingContent = false);
  }

  void _prevChapter() { if (_currentIndex > 0) _loadContent(_currentIndex - 1); }
  void _nextChapter() { if (_currentIndex < _chapters.length - 1) _loadContent(_currentIndex + 1); }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.readerThemes[_currentTheme]!;
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: GestureDetector(
        onTap: () => setState(() => _showMenu = !_showMenu),
        child: Stack(children: [
          // Content
          Positioned.fill(child: Column(children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 8),
            if (_showMenu) _buildTopBar(theme),
            Expanded(child: _isLoadingContent
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_chapters.isNotEmpty ? _chapters[_currentIndex].title : "",
                      style: TextStyle(fontSize: _fontSize + 4, fontWeight: FontWeight.bold, color: theme.textColor, height: 1.6)),
                    const SizedBox(height: 16),
                    Text(_content, style: TextStyle(fontSize: _fontSize, color: theme.textColor, height: 1.8, letterSpacing: 0.5)),
                    const SizedBox(height: 60),
                  ]),
                )),
            Container(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 4),
              child: Center(child: Text((_currentIndex + 1).toString() + " / " + _chapters.length.toString(),
                style: TextStyle(fontSize: 12, color: theme.textColor.withValues(alpha: 0.5))))),
          ])),
          // Tap zones
          if (!_showMenu) Row(children: [
            Expanded(child: GestureDetector(onTap: _prevChapter, child: Container(color: Colors.transparent))),
            Container(width: 80, color: Colors.transparent),
            Expanded(child: GestureDetector(onTap: _nextChapter, child: Container(color: Colors.transparent))),
          ]),
          // Menu overlay
          if (_showMenu) _buildBottomMenu(theme),
        ]),
      ),
    );
  }

  Widget _buildTopBar(ReaderTheme theme) {
    return Container(color: theme.bgColor, child: Row(children: [
      IconButton(icon: Icon(Icons.arrow_back, color: theme.textColor), onPressed: () => Navigator.pop(context)),
      Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(
        _chapters.isNotEmpty ? _chapters[_currentIndex].title : "", style: TextStyle(color: theme.textColor, fontSize: 14)))),
      IconButton(icon: Icon(Icons.menu, color: theme.textColor), onPressed: () {}),
    ]));
  }

  Widget _buildBottomMenu(ReaderTheme theme) {
    return Positioned(left: 0, right: 0, bottom: 0,
      child: Container(color: theme.bgColor.withValues(alpha: 0.97),
        child: SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Chapter selector
          SizedBox(height: 40, child: ListView.builder(
            scrollDirection: Axis.horizontal, itemCount: _chapters.length,
            itemBuilder: (ctx, i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ActionChip(label: Text((i + 1).toString(), style: TextStyle(fontSize: 11,
                color: i == _currentIndex ? Colors.white : theme.textColor)),
                backgroundColor: i == _currentIndex ? AppTheme.primaryColor : null,
                onPressed: () => _loadContent(i))))),
          const Divider(height: 1),
          // Font size slider
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(children: [
              const Icon(Icons.text_fields, size: 16),
              Expanded(child: Slider(value: _fontSize, min: 12, max: 32, onChanged: (v) => setState(() => _fontSize = v))),
            ])),
          // Theme selection
          Padding(padding: const EdgeInsets.only(bottom: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppTheme.readerThemes.entries.map((e) {
                final active = _currentTheme == e.key;
                return GestureDetector(onTap: () => setState(() => _currentTheme = e.key),
                  child: Column(children: [
                    Container(width: 32, height: 32, decoration: BoxDecoration(
                      color: e.value.bgColor, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: active ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3), width: 2)),
                      child: active ? Icon(Icons.check, size: 14, color: e.value.textColor) : null),
                    Text(e.value.name, style: TextStyle(fontSize: 9, color: theme.textColor)),
                  ]));
              }).toList())),
        ]))));
  }
}
