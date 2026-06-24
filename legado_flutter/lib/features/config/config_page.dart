import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("主题设置")),
      body: ListView(children: [
        Card(margin: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text("阅读主题", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(spacing: 12, runSpacing: 12, children: AppTheme.readerThemes.entries.map((e) =>
              Column(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: e.value.bgColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.withValues(alpha: 0.3)))),
                const SizedBox(height: 4), Text(e.value.name, style: const TextStyle(fontSize: 12)),
              ])).toList())),
        ])),
      ]),
    );
  }
}
