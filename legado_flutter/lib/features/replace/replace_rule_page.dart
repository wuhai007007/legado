import 'package:flutter/material.dart';
import '../../core/database/daos/replace_rule_dao.dart';
import '../../core/models/replace_rule.dart';

class ReplaceRulePage extends StatefulWidget {
  const ReplaceRulePage({super.key});
  @override
  State<ReplaceRulePage> createState() => _ReplaceRulePageState();
}

class _ReplaceRulePageState extends State<ReplaceRulePage> {
  final _dao = ReplaceRuleDao();
  List<ReplaceRule> _rules = [];

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { _rules = await _dao.getAll(); setState(() {}); } catch (_) {} }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("替换净化"), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () => _edit(context))
      ]),
      body: _rules.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.find_replace, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16), const Text("暂无替换规则"),
          ]))
        : ListView.builder(itemCount: _rules.length, itemBuilder: (ctx, i) {
            final r = _rules[i];
            return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), child: ListTile(
              leading: Switch(value: r.enabled, onChanged: (v) async { r.enabled = v; setState(() {}); }),
              title: Text(r.name ?? "未命名", style: const TextStyle(fontSize: 14)),
              subtitle: Text((r.pattern ?? "") + " -> " + (r.replacement ?? ""), style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () async { if (r.id != null) await _dao.delete(r.id!); _load(); }),
              onTap: () => _edit(context, rule: r),
            ));
          }),
    );
  }

  void _edit(BuildContext context, {ReplaceRule? rule}) {
    final nameC = TextEditingController(text: rule?.name ?? "");
    final patternC = TextEditingController(text: rule?.pattern ?? "");
    final replaceC = TextEditingController(text: rule?.replacement ?? "");
    bool isRegex = rule?.isRegex ?? false;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      title: Text(rule != null ? "编辑规则" : "新建规则"),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: "规则名称", border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: patternC, decoration: InputDecoration(labelText: "查找内容", border: const OutlineInputBorder(),
          suffixIcon: TextButton(onPressed: () => setSt(() => isRegex = !isRegex), child: Text(isRegex ? "正则" : "文本", style: const TextStyle(fontSize: 12)))), maxLines: 2),
        const SizedBox(height: 8),
        TextField(controller: replaceC, decoration: const InputDecoration(labelText: "替换为", border: OutlineInputBorder()), maxLines: 2),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
        FilledButton(onPressed: () async {
          final r = rule ?? ReplaceRule();
          r.name = nameC.text; r.pattern = patternC.text; r.replacement = replaceC.text; r.isRegex = isRegex;
          if (rule == null) await _dao.insert(r); else await _dao.update(r);
          Navigator.pop(ctx); _load();
        }, child: const Text("保存")),
      ],
    )));
  }
}
