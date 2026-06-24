import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _results = [];
  final List<String> _history = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) return;
    setState(() => _isSearching = true);
    _results.clear();
    await Future.delayed(const Duration(seconds: 1));
    _results.add({"name": keyword + " 搜索结果1", "author": "作者A"});
    _results.add({"name": keyword + " 搜索结果2", "author": "作者B"});
    if (!_history.contains(keyword)) {
      _history.insert(0, keyword);
      if (_history.length > 10) _history.removeLast();
    }
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "搜索书名或作者",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(_searchController.text),
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _results.isNotEmpty
              ? ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final book = _results[index];
                    return ListTile(
                      leading: Container(
                        width: 36, height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.book, size: 20),
                      ),
                      title: Text(book["name"] ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: (book["author"] ?? "").isNotEmpty ? Text(book["author"]!) : null,
                    );
                  },
                )
              : _buildHistory(),
    );
  }

  Widget _buildHistory() {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("搜索你想看的书", style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("搜索历史", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() => _history.clear()),
                child: const Text("清除"),
              ),
            ],
          ),
        ),
        ..._history.map((h) => ListTile(
          leading: const Icon(Icons.history, size: 20),
          title: Text(h),
          onTap: () {
            _searchController.text = h;
            _search(h);
          },
        )),
      ],
    );
  }
}
