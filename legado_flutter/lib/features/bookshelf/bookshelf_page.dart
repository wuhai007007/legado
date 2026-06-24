import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../reader/reader_page.dart';
import '../search/search_page.dart';
import '../book_info/book_info_page.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _books = [];
  bool _isLoading = true;
  bool _isGrid = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    // TODO: Load from database
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('书架'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? _buildEmptyState()
              : _isGrid ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('书架空空如也', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text('点击右上角搜索添加书籍', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
            icon: const Icon(Icons.search),
            label: const Text('搜索书籍'),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: _loadBooks,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 40, height: 56,
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: const Icon(Icons.book, color: AppTheme.primaryColor),
                ),
              ),
              title: Text(book['name'] ?? '未知书名'),
              subtitle: Text(book['author'] ?? '', style: const TextStyle(fontSize: 12)),
              trailing: Text(book['latestChapter'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReaderPage())),
              onLongPress: () => _showBookMenu(book),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    return RefreshIndicator(
      onRefresh: _loadBooks,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: max(1, _books.length),
        itemBuilder: (context, index) {
          if (_books.isEmpty) {
            return Center(child: Text('暂无书籍', style: TextStyle(color: Colors.grey[400])));
          }
          final book = _books[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReaderPage())),
            onLongPress: () => _showBookMenu(book),
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: const Center(child: Icon(Icons.book, size: 48, color: AppTheme.primaryColor)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      book['name'] ?? '',
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.import_export), title: const Text('导入书源'), onTap: () { Navigator.pop(ctx); }),
            ListTile(leading: const Icon(Icons.download), title: const Text('本地导入'), onTap: () { Navigator.pop(ctx); }),
            ListTile(leading: const Icon(Icons.cloud_download), title: const Text('WebDAV同步'), onTap: () { Navigator.pop(ctx); }),
            if (_books.isNotEmpty)
              ListTile(leading: const Icon(Icons.edit), title: const Text('管理书架'), onTap: () { Navigator.pop(ctx); }),
          ],
        ),
      ),
    );
  }

  void _showBookMenu(Map<String, dynamic> book) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(book['name'] ?? ''), subtitle: Text(book['author'] ?? '')),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.info_outline), title: const Text('详情'), onTap: () { Navigator.pop(ctx); }),
            ListTile(leading: const Icon(Icons.bookmark_border), title: const Text('书签'), onTap: () { Navigator.pop(ctx); }),
            ListTile(leading: const Icon(Icons.delete_outline), title: const Text('移除'), onTap: () { Navigator.pop(ctx); }),
          ],
        ),
      ),
    );
  }
}

