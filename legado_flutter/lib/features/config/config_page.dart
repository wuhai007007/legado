import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主题设置')),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('阅读主题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 12, runSpacing: 12,
                    children: AppTheme.readerThemes.entries.map((entry) {
                      return Column(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: entry.value.bgColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(entry.value.name, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SwitchListTile(title: const Text('跟随系统深色模式'), value: true, onChanged: (v) {}),
                SwitchListTile(title: const Text('音量键翻页'), value: true, onChanged: (v) {}),
                SwitchListTile(title: const Text('显示行距调整'), value: false, onChanged: (v) {}),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('缓存', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('清除图片缓存'),
                  trailing: Text('0.0 MB', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('清除WebView缓存'),
                  trailing: Text('0.0 MB', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
