import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import '../../core/database/daos/rss_dao.dart';
import '../../core/models/rss_source.dart';
import '../../core/models/rss_article.dart';
import '../../core/services/http/http_helper.dart';

class RssPage extends StatefulWidget {
  const RssPage({super.key});
  @override
  State<RssPage> createState() => _RssPageState();
}

class _RssPageState extends State<RssPage> with AutomaticKeepAliveClientMixin {
  final _dao = RssDao();
  List<RssSource> _sources = [];
  bool _loading = true;
  @override bool get wantKeepAlive => true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try { _sources = await _dao.getAllSources(); } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _fetchRss(RssSource source) async {
    try {
      final resp = await HttpHelper.get(source.rssSourceUrl, sourceHeader: source.header);
      if (!resp.isSuccess) return;
      final doc = XmlDocument.parse(resp.body);
      final articles = <RssArticle>[];

      // Try RSS 2.0
      var items = doc.findAllElements("item");
      if (items.isEmpty) items = doc.findAllElements("entry"); // Atom

      for (final item in items) {
        final title = item.findElements("title").firstOrNull?.innerText ?? "";
        final link = item.findElements("link").firstOrNull?.innerText ?? "";
        if (title.isEmpty) continue;
        final desc = item.findElements("description").firstOrNull?.innerText ?? "";
        final author = item.findElements("author").firstOrNull?.innerText ?? "";
        final pubDate = item.findElements("pubDate").firstOrNull?.innerText ?? "";
        articles.add(RssArticle(rssSourceUrl: source.rssSourceUrl, title: title, link: link, description: desc, author: author, pubDate: pubDate));
      }
      if (articles.isNotEmpty) {
        await _dao.bulkInsertArticles(articles);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("获取到 " + articles.length.toString() + " 篇文章")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("获取失败: " + e.toString())));
    }
  }

  void _showAddDialog(BuildContext context) {
    final urlC = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("添加RSS源"),
      content: TextField(controller: urlC, decoration: const InputDecoration(hintText: "输入RSS订阅地址", border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
        FilledButton(onPressed: () async {
          if (urlC.text.isNotEmpty) {
            final src = RssSource(rssSourceUrl: urlC.text, rssSourceName: urlC.text);
            await _dao.insertSource(src);
            Navigator.pop(ctx);
            _load();
            _fetchRss(src);
          }
        }, child: const Text("添加并获取")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text("订阅"), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddDialog(context)),
      ]),
      body: _loading ? const Center(child: CircularProgressIndicator())
        : _sources.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.rss_feed, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16), const Text("暂无订阅源"),
              const SizedBox(height: 8), Text("点击右上角添加RSS源", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ]))
          : RefreshIndicator(onRefresh: _load,
              child: ListView.builder(itemCount: _sources.length, itemBuilder: (ctx, i) {
                final s = _sources[i];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: ListTile(
                    leading: const Icon(Icons.rss_feed, color: Colors.orange),
                    title: Text(s.rssSourceName, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(s.rssSourceUrl, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.refresh, size: 20), onPressed: () => _fetchRss(s)),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () async { await _dao.deleteSource(s); _load(); }),
                    ]),
                    onTap: () => _showArticles(context, s),
                  ));
              })),
    );
  }

  void _showArticles(BuildContext context, RssSource source) async {
    final articles = await _dao.getArticles(source.rssSourceUrl);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("共 " + articles.length.toString() + " 篇文章")));
  }
}
