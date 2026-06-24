import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.menu_book, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text('开源阅读', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Legado', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                const Text('v1.0.0', style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const ListTile(title: Text('开源协议'), trailing: Text('GPL-3.0', style: TextStyle(color: Colors.grey))),
                const Divider(height: 1, indent: 16),
                ListTile(
                  title: const Text('源代码'),
                  trailing: const Icon(Icons.open_in_new, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16),
                const ListTile(title: Text('反馈'), trailing: Icon(Icons.open_in_new, size: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
