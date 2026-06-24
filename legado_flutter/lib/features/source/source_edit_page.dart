import 'package:flutter/material.dart';
import '../../core/models/book_source.dart';

class SourceEditPage extends StatefulWidget {
  final BookSource? source;
  const SourceEditPage({super.key, this.source});

  @override
  State<SourceEditPage> createState() => _SourceEditPageState();
}

class _SourceEditPageState extends State<SourceEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _searchUrlController;
  late TextEditingController _headerController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.source?.bookSourceName ?? '');
    _urlController = TextEditingController(text: widget.source?.bookSourceUrl ?? '');
    _searchUrlController = TextEditingController(text: widget.source?.searchUrl ?? '');
    _headerController = TextEditingController(text: widget.source?.header ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _searchUrlController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source != null ? '编辑书源' : '新建书源'),
        actions: [
          IconButton(icon: const Icon(Icons.code), onPressed: () => _showDebugPage(context)),
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '书源名称', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: '书源URL', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchUrlController,
            decoration: const InputDecoration(
              labelText: '搜索地址',
              hintText: '例如: https://example.com/search?key={{key}}',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _headerController,
            decoration: const InputDecoration(
              labelText: '请求头',
              hintText: 'JSON格式',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('书源已保存')),
    );
    Navigator.pop(context);
  }

  void _showDebugPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('书源调试')),
        body: const Center(child: Text('书源调试功能')),
      ),
    ));
  }
}
