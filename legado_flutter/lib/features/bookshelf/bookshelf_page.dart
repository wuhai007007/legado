import "package:flutter/material.dart";
import "../../core/database/daos/book_dao.dart";
import "../../core/database/daos/book_chapter_dao.dart";
import "../../core/models/book.dart";
import "../../core/services/source/book_source_service.dart";
import "../../core/database/daos/book_source_dao.dart";
import "../../core/models/book_source.dart";
import "../../core/services/http/http_helper.dart";
import "../../theme/app_theme.dart";
import "../reader/reader_page.dart";
import "../book_info/book_info_page.dart";
import "../search/search_page.dart";
import "../replace/replace_rule_page.dart";
import "../source/source_manage_page.dart";

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});
  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> with AutomaticKeepAliveClientMixin {
  final _dao = BookDao(); final _sourceDao = BookSourceDao();
  List<Book> _books = []; bool _isLoading = true; bool _isGrid = false;
  @override bool get wantKeepAlive => true;

  @override
  void initState() { super.initState(); _loadBooks(); }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    try { _books = await _dao.getAll(); } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text("\u4e66\u67b6 (" + _books.length.toString() + ")"), actions: [
        IconButton(icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view), onPressed: () => setState(() => _isGrid = !_isGrid)),
        IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())).then((_) => _loadBooks())),
        PopupMenuButton<String>(onSelected: (v) {
          if (v == "source") Navigator.push(context, MaterialPageRoute(builder: (_) => const SourceManagePage())).then((_) => _loadBooks());
          if (v == "replace") Navigator.push(context, MaterialPageRoute(builder: (_) => const ReplaceRulePage()));
        }, itemBuilder: (_) => const [
          PopupMenuItem(value: "source", child: ListTile(leading: Icon(Icons.source), title: Text("\u4e66\u6e90\u7ba1\u7406"))),
          PopupMenuItem(value: "replace", child: ListTile(leading: Icon(Icons.find_replace), title: Text("\u66ff\u6362\u51c0\u5316"))),
        ]),
      ]),
      body: _isLoading ? const Center(child: CircularProgressIndicator())
        : _books.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.menu_book_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16), const Text("\u4e66\u67b6\u7a7a\u7a7a\u5982\u4e5f", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())).then((_) => _loadBooks()),
              icon: const Icon(Icons.search), label: const Text("\u641c\u7d22\u4e66\u7c4d")),
          ]))
        : RefreshIndicator(onRefresh: _loadBooks,
            child: _isGrid ? _buildGrid() : _buildList()),
    );
  }

  Widget _buildList() {
    return ListView.builder(padding: const EdgeInsets.all(8), itemCount: _books.length, itemBuilder: (ctx, i) {
      final b = _books[i];
      final p = b.totalChapterNum > 0 ? (b.durChapterIndex + 1).toString() + "/" + b.totalChapterNum.toString() : "";
      return Card(child: ListTile(
        leading: Container(width: 40, height: 56, decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: const Icon(Icons.book, color: AppTheme.primaryColor)),
        title: Text(b.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(b.author.isNotEmpty ? b.author + "  " + p : p, style: const TextStyle(fontSize: 12)),
        trailing: b.latestChapterTitle != null ? Text(b.latestChapterTitle!, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1) : null,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderPage(book: b))).then((_) => _loadBooks()),
      ));
    });
  }

  Widget _buildGrid() {
    return GridView.builder(padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.65, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: _books.length, itemBuilder: (ctx, i) {
        final b = _books[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderPage(book: b))).then((_) => _loadBooks()),
          child: Card(child: Column(children: [
            Expanded(child: Container(decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
              child: const Center(child: Icon(Icons.book, size: 48, color: AppTheme.primaryColor)))),
            Padding(padding: const EdgeInsets.all(6), child: Text(b.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
          ])));
      });
  }
}

