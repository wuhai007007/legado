import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../source/source_manage_page.dart';
import '../replace/replace_rule_page.dart';
import '../config/config_page.dart';
import '../about/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        children: [
          // User info
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('开源阅读 Legado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('自由·无广告·开源', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Menu items
          _buildMenuGroup(context, '阅读管理', [
            _MenuItem(Icons.book_outlined, '书源管理', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SourceManagePage()))),
            _MenuItem(Icons.rule, '替换净化', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReplaceRulePage()))),
            _MenuItem(Icons.folder_outlined, '本地书籍', () {}),
          ]),
          _buildMenuGroup(context, '数据管理', [
            _MenuItem(Icons.backup_outlined, '备份与恢复', () => _showComingSoon(context)),
            _MenuItem(Icons.cloud_sync_outlined, 'WebDAV同步', () => _showComingSoon(context)),
            _MenuItem(Icons.import_export, '导入导出', () => _showComingSoon(context)),
          ]),
          _buildMenuGroup(context, '设置', [
            _MenuItem(Icons.palette_outlined, '主题设置', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigPage()))),
            _MenuItem(Icons.download_outlined, '缓存管理', () => _showComingSoon(context)),
            _MenuItem(Icons.info_outline, '关于', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()))),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Column(
            children: items.map((item) => ListTile(
              leading: Icon(item.icon, size: 22),
              title: Text(item.title, style: const TextStyle(fontSize: 15)),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: item.onTap,
            )).toList(),
          ),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('功能开发中，敬请期待')),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  _MenuItem(this.icon, this.title, this.onTap);
}
