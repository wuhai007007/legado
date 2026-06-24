import 'package:flutter/material.dart';
import '../../core/database/daos/book_source_dao.dart';
import '../../core/models/book_source.dart';
import '../../theme/app_theme.dart';
import 'source_edit_page.dart';

class SourceManagePage extends StatefulWidget {
  const SourceManagePage({super.key});

  @override
  State<SourceManagePage> createState() => _SourceManagePageState();
}

class _SourceManagePageState extends State<SourceManagePage> {
  List<BookSource> _sources = [];
  bool _isLoading = true;
  final _dao = BookSourceDao();

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    setState(() => _isLoading = true);
    try {
      final sources = await _dao.getAll();
      setState(() {
        _sources = sources;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书源管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSourceDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _showImportDialog(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sources.isEmpty
              ? _buildEmptyState()
              : _buildSourceList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.source_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('暂无书源', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showImportDialog(context),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('导入书源'),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceList() {
    int enabledCount = _sources.where((s) => s.enabled).length;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: Colors.grey[100],
          child: Row(
            children: [
              Text('共 ${_sources.length} 个书源', style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              Text('已启用 $enabledCount', style: TextStyle(fontSize: 13, color: Colors.green[600])),
              const Spacer(),
              TextButton(
                onPressed: () => _showGroupManage(context),
                child: const Text('分组管理', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadSources,
            child: ListView.builder(
              itemCount: _sources.length,
              itemBuilder: (context, index) {
                final source = _sources[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: ListTile(
                    leading: Switch(
                      value: source.enabled,
                      onChanged: (v) async {
                        source.enabled = v;
                        await _dao.update(source);
                        setState(() {});
                      },
                    ),
                    title: Text(source.bookSourceName, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(source.bookSourceUrl, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (source.bookSourceGroup != null && source.bookSourceGroup!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(source.bookSourceGroup!, style: const TextStyle(fontSize: 11, color: AppTheme.primaryColor)),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SourceEditPage(source: source)));
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SourceEditPage(source: source)));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSourceDialog(BuildContext context) {
    final urlController = TextEditingController();
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加书源'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '书源名称', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: '书源URL', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              if (urlController.text.isNotEmpty) {
                final source = BookSource(
                  bookSourceName: nameController.text.isNotEmpty ? nameController.text : urlController.text,
                  bookSourceUrl: urlController.text,
                );
                await _dao.insert(source);
                Navigator.pop(ctx);
                _loadSources();
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('导入书源', style: TextStyle(fontSize: 18))),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('从网络导入'),
              onTap: () { Navigator.pop(ctx); },
            ),
            ListTile(
              leading: const Icon(Icons.file_open),
              title: const Text('从文件导入'),
              onTap: () { Navigator.pop(ctx); },
            ),
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: const Text('从剪贴板导入'),
              onTap: () { Navigator.pop(ctx); },
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupManage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('分组管理'),
        content: const Text('分组管理功能开发中'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭'))],
      ),
    );
  }
}
