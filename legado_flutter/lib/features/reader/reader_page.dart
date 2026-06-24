import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final List<String> _chapters = [];
  final List<String> _content = [];
  int _currentPage = 0;
  bool _showMenu = false;
  String _currentTheme = 'yellow';
  double _fontSize = 18.0;
  double _lineHeight = 1.6;
  bool _isLoading = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _chapters.addAll([
        '第一章 开端', '第二章 相遇', '第三章 发展', '第四章 转折',
        '第五章 高潮', '第六章 结局'
      ]);
      for (int i = 0; i < 6; i++) {
        _content.add('这是第${i+1}章的内容。\n\n' * 20);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.readerThemes[_currentTheme]!;
    
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: GestureDetector(
        onTap: () => setState(() => _showMenu = !_showMenu),
        child: Stack(
          children: [
            // Reader content
            Positioned.fill(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top + 8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _chapters[_currentPage],
                                  style: TextStyle(
                                    fontSize: _fontSize + 4,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                    height: _lineHeight,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _content[_currentPage],
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    color: theme.textColor,
                                    height: _lineHeight,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                        // Progress bar
                        Container(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_currentPage + 1} / ${_chapters.length}',
                                style: TextStyle(fontSize: 12, color: theme.textColor.withValues(alpha: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            // Tap zones for page turning
            if (!_showMenu)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Container(width: 60, color: Colors.transparent),
                  Expanded(
                    child: GestureDetector(
                      onTap: _currentPage < _chapters.length - 1 ? () => setState(() => _currentPage++) : null,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            // Menu overlay
            if (_showMenu)
              _buildMenuOverlay(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOverlay(ReaderTheme theme) {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        color: theme.bgColor.withValues(alpha: 0.95),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top menu bar
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildChapterChips(theme),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu, color: theme.textColor),
                    onPressed: () => _showChapterList(theme),
                  ),
                ],
              ),
              const Divider(height: 1),
              // Reader settings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Font size
                    Row(
                      children: [
                        const Icon(Icons.text_fields, size: 16),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 12, max: 32,
                            onChanged: (v) => setState(() => _fontSize = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Theme selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: AppTheme.readerThemes.entries.map((entry) {
                        final isActive = _currentTheme == entry.key;
                        return GestureDetector(
                          onTap: () => setState(() => _currentTheme = entry.key),
                          child: Column(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: entry.value.bgColor,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isActive ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                  boxShadow: isActive
                                      ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 4)]
                                      : null,
                                ),
                                child: isActive
                                    ? Icon(Icons.check, size: 16, color: entry.value.textColor)
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(entry.value.name, style: TextStyle(fontSize: 10, color: theme.textColor)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChapterChips(ReaderTheme theme) {
    return List.generate(_chapters.length, (i) {
      final isCurrent = i == _currentPage;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ActionChip(
          label: Text('${i + 1}', style: TextStyle(fontSize: 11, color: isCurrent ? Colors.white : theme.textColor)),
          backgroundColor: isCurrent ? AppTheme.primaryColor : null,
          onPressed: () => setState(() => _currentPage = i),
        ),
      );
    });
  }

  void _showChapterList(ReaderTheme theme) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        color: theme.bgColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text('目录', style: TextStyle(fontSize: 18, color: theme.textColor)),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (context, i) {
                  final isCurrent = i == _currentPage;
                  return ListTile(
                    selected: isCurrent,
                    selectedTileColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    title: Text(
                      _chapters[i],
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isCurrent ? const Icon(Icons.chevron_right, size: 16) : null,
                    onTap: () {
                      setState(() => _currentPage = i);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
