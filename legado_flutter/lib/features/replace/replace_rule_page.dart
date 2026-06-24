import 'package:flutter/material.dart';
import '../../core/database/daos/replace_rule_dao.dart';
import '../../core/models/replace_rule.dart';

class ReplaceRulePage extends StatefulWidget {
  const ReplaceRulePage({super.key});

  @override
  State<ReplaceRulePage> createState() => _ReplaceRulePageState();
}

class _ReplaceRulePageState extends State<ReplaceRulePage> {
  List<ReplaceRule> _rules = [];
  final _dao = ReplaceRuleDao();

  @override
  void initState() {
    super.initState();
    _loadRules();
  }

  Future<void> _loadRules() async {
    try {
      final rules = await _dao.getAll();
      setState(() => _rules = rules);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('替换净化'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: _rules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.find_replace, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('暂无替换规则', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('添加规则来自动替换正文中的内容', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                final rule = _rules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: ListTile(
                    leading: Switch(
                      value: rule.enabled,
                      onChanged: (v) async {
                        rule.enabled = v;
                        setState(() {});
                      },
                    ),
                    title: Text(rule.name ?? '未命名', style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                      '${rule.pattern ?? ""} → ${rule.replacement ?? ""}',
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      onPressed: () {
                        if (rule.id != null) _dao.delete(rule.id!);
                        _loadRules();
                      },
                    ),
                    onTap: () => _showEditDialog(context, rule: rule),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDialog(BuildContext context, {ReplaceRule? rule}) {
    final nameController = TextEditingController(text: rule?.name ?? '');
    final patternController = TextEditingController(text: rule?.pattern ?? '');
    final replacementController = TextEditingController(text: rule?.replacement ?? '');
    bool isRegex = rule?.isRegex ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(rule != null ? '编辑规则' : '新建规则'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '规则名称', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: patternController,
                  decoration: InputDecoration(
                    labelText: '查找内容',
                    border: const OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: () => setDialogState(() => isRegex = !isRegex),
                      child: Text(isRegex ? '正则' : '文本', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: replacementController,
                  decoration: const InputDecoration(labelText: '替换为', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _loadRules();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
