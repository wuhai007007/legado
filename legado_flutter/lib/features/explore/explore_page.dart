import 'package:flutter/material.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/models/book_source.dart';
import '../../core/services/source/book_source_service.dart';
import '../search/search_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  final _sourceDao = BookSourceDao();
  List<BookSource> _sources = [];
  @override bool get wantKeepAlive => true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try { _sources = await _sourceDao.getEnabled(); setState(() {}); } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text("发现"), actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()))),
      ]),
      body: _sources.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.explore, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16), const Text("发现页需要书源支持"),
            const SizedBox(height: 8), Text("请先在书源管理中导入书源", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ]))
        : ListView.builder(itemCount: _sources.length, itemBuilder: (ctx, i) {
            final s = _sources[i];
            return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: ListTile(
                leading: const Icon(Icons.source, color: Colors.blue),
                title: Text(s.bookSourceName, style: const TextStyle(fontSize: 14)),
                subtitle: s.exploreUrl != null ? Text(s.exploreUrl!, style: const TextStyle(fontSize: 11), maxLines: 1) : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, // TODO: explore url
              ));
          }),
    );
  }
}
