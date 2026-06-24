import 'package:flutter/material.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/database/daos/book_dao.dart';
import '../../core/services/source/book_source_service.dart';
import '../../core/models/search_book.dart';
import '../../core/models/book_source.dart';
import '../../core/models/book.dart';
import '../../core/services/http/http_helper.dart';
import '../../theme/app_theme.dart';
import '../book_info/book_info_page.dart';
import '../source/source_manage_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtl = TextEditingController();
  final _results = <SearchBook>[];
  final _history = <String>[];
  final _sourceDao = BookSourceDao();
  final _bookDao = BookDao();
  bool _isSearching = false;
  String _statusText = '';

  @override
  void dispose() { _searchCtl.dispose(); super.dispose(); }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) return;
    setState(() { _isSearching = true; _results.clear(); _statusText = '搜索中...'; });
    final sources = await _sourceDao.getEnabled();
    if (sources.isEmpty) {
      setState(() { _isSearching = false; _statusText = '没有启用的书源，请先添加书源'; });
      return;
    }
    for (final source in sources) {
      try {
        final svc = BookSourceService(source);
        final books = await svc.search(keyword);
        _results.addAll(books);
        setState(() => _statusText = '已搜索 ' + source.bookSourceName + ' (' + books.length.toString() + '条)');
      } catch (_) {}
      if (_results.length > 100) break;
    }
    if (!_history.contains(keyword)) {
      _history.insert(0, keyword);
      if (_history.length > 10) _history.removeLast();
    }
    setState(() { _isSearching = false; _statusText = '共 ' + _results.length.toString() + ' 条结果'; });
  }

  void _addToBookshelf(SearchBook sb) async {
    final book = Book(
      bookUrl: sb.bookUrl, name: sb.name, author: sb.author,
      origin: sb.origin, originName: sb.originName, kind: sb.kind,
      coverUrl: sb.coverUrl, intro: sb.intro, tocUrl: sb.tocUrl,
      originOrder: sb.originOrder, wordCount: sb.wordCount, type: sb.type,
    );
    await _bookDao.insert(book);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('《' + sb.name + '》已加入书架')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: _searchCtl, autofocus: true,
          decoration: const InputDecoration(hintText: '搜索书名或作者', border: InputBorder.none, contentPadding: EdgeInsets.zero),
          onSubmitted: _search),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => _search(_searchCtl.text))],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _results.isNotEmpty
              ? Column(children: [
                  if (_statusText.isNotEmpty)
                    Container(padding: const EdgeInsets.all(8), color: Colors.grey[100], width: double.infinity,
                      child: Text(_statusText, style: const TextStyle(fontSize: 12))),
                  Expanded(child: ListView.builder(itemCount: _results.length, itemBuilder: (ctx, i) {
                    final book = _results[i];
                    return ListTile(
                      leading: Container(width: 36, height: 50,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.book, size: 20)),
                      title: Text(book.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text((book.author.isNotEmpty ? book.author + ' | ' : '') + book.originName, style: const TextStyle(fontSize: 12)),
                      trailing: IconButton(icon: const Icon(Icons.add_circle_outline, size: 20), onPressed: () => _addToBookshelf(book)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookInfoPage(searchBook: book))),
                    );
                  })),
                ])
              : _buildHistory(),
    );
  }

  Widget _buildHistory() {
    if (_statusText.isNotEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(_statusText, style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
      ]));
    }
    if (_history.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.search, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        const Text('搜索你想看的书', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SourceManagePage())), child: const Text('管理书源')),
      ]));
    }
    return ListView(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Row(children: [
        const Text('搜索历史', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(onPressed: () => setState(() => _history.clear()), child: const Text('清除')),
      ])),
      ..._history.map((h) => ListTile(leading: const Icon(Icons.history, size: 20), title: Text(h),
          onTap: () { _searchCtl.text = h; _search(h); })),
    ]);
  }
}

