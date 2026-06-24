import 'package:flutter/material.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/models/book_source.dart';
import '../../core/services/http/http_helper.dart';
import '../../theme/app_theme.dart';
import 'source_edit_page.dart';

class SourceManagePage extends StatefulWidget {
  const SourceManagePage({super.key});
  @override
  State<SourceManagePage> createState() => _SourceManagePageState();
}

class _SourceManagePageState extends State<SourceManagePage> {
  final _dao = BookSourceDao();
  List<BookSource> _sources = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _isLoading = true);
    try { _sources = await _dao.getAll(); } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ec = _sources.where((s) => s.enabled).length;
    return Scaffold(
      appBar: AppBar(title: const Text("书源管理"), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () => _showAdd(context)),
        PopupMenuButton<String>(onSelected: (v) => _handleImport(context, v),
          itemBuilder: (_) => const [
            PopupMenuItem(value: "url", child: Text("从网络导入")),
            PopupMenuItem(value: "clipboard", child: Text("从剪贴板导入")),
          ]),
      ]),
      body: _isLoading ? const Center(child: CircularProgressIndicator())
        : Column(children: [
          Container(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), color: Colors.grey[100],
            child: Row(children: [
              Text("共 " + _sources.length.toString() + " 个书源"),
              const SizedBox(width: 8),
              Text("已启用 " + ec.toString(), style: TextStyle(color: Colors.green[600])),
            ])),
          Expanded(child: RefreshIndicator(onRefresh: _load,
            child: ListView.builder(itemCount: _sources.length, itemBuilder: (ctx, i) {
              final s = _sources[i];
              return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), child: ListTile(
                leading: Switch(value: s.enabled, onChanged: (v) async { s.enabled = v; await _dao.update(s); setState(() {}); }),
                title: Text(s.bookSourceName, style: const TextStyle(fontSize: 14)),
                subtitle: Text(s.bookSourceUrl, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () async { await _dao.delete(s); _load(); }),
              ));
            }))),
        ]),
    );
  }

  void _showAdd(BuildContext context) {
    final nameC = TextEditingController(); final urlC = TextEditingController(); final searchC = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("添加书源"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: "书源名称", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: urlC, decoration: const InputDecoration(labelText: "书源URL", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: searchC, decoration: const InputDecoration(labelText: "搜索地址", border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
        FilledButton(onPressed: () async {
          if (urlC.text.isNotEmpty) {
            await _dao.insert(BookSource(bookSourceName: nameC.text.isNotEmpty ? nameC.text : urlC.text, bookSourceUrl: urlC.text, searchUrl: searchC.text));
            Navigator.pop(ctx); _load();
          }
        }, child: const Text("添加")),
      ],
    ));
  }

  void _handleImport(BuildContext context, String type) {
    if (type == "url") {
      final urlC = TextEditingController();
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("从网络导入"),
        content: TextField(controller: urlC, decoration: const InputDecoration(hintText: "输入书源JSON地址", border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
          FilledButton(onPressed: () async {
            if (urlC.text.isNotEmpty) {
              try {
                final resp = await HttpHelper.get(urlC.text);
                if (resp.isSuccess) { await _dao.importFromJson(resp.body); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("导入成功"))); }
              } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("导入失败: " + e.toString()))); }
              Navigator.pop(ctx); _load();
            }
          }, child: const Text("导入")),
        ],
      ));
    }
  }
}
