import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../source/source_manage_page.dart';
import '../replace/replace_rule_page.dart';
import '../config/config_page.dart';
import '../about/about_page.dart';
import '../rss/rss_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("我的")),
      body: ListView(children: [
        Container(padding: const EdgeInsets.all(20), color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(children: [
            CircleAvatar(radius: 30, backgroundColor: AppTheme.primaryColor, child: const Icon(Icons.person, size: 32, color: Colors.white)),
            const SizedBox(width: 16),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("开源阅读 Legado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("自由 无广告 开源", style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),
          ])),
        _group("阅读管理", [MenuItem(Icons.source, "书源管理", () => _push(context, const SourceManagePage())), MenuItem(Icons.find_replace, "替换净化", () => _push(context, const ReplaceRulePage()))]),
        _group("订阅", [MenuItem(Icons.rss_feed, "RSS订阅", () => _push(context, const RssPage()))]),
        _group("设置", [MenuItem(Icons.palette, "主题设置", () => _push(context, const ConfigPage())), MenuItem(Icons.info, "关于", () => _push(context, const AboutPage()))]),
      ]),
    );
  }

  Widget _group(String title, List<MenuItem> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
      Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), child: Column(
        children: items.map((item) => ListTile(leading: Icon(item.icon, size: 22), title: Text(item.title, style: const TextStyle(fontSize: 15)), trailing: const Icon(Icons.chevron_right, size: 18), onTap: item.onTap)).toList())),
    ]);
  }

  void _push(BuildContext context, Widget page) { Navigator.push(context, MaterialPageRoute(builder: (_) => page)); }
}

class MenuItem {
  final IconData icon; final String title; final VoidCallback onTap;
  MenuItem(this.icon, this.title, this.onTap);
}
