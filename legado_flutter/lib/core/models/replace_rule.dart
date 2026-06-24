class ReplaceRule {
  int? id;
  int? order;
  bool enabled;
  bool isRegex;
  String? name;
  String? pattern;
  String? replacement;
  String? source;

  ReplaceRule({this.id, this.order, this.enabled = true, this.isRegex = false, this.name, this.pattern, this.replacement, this.source});

  factory ReplaceRule.fromMap(Map<String, dynamic> map) => ReplaceRule(
    id: map['id'], order: map['order'], enabled: (map['enabled'] ?? 1) == 1,
    isRegex: (map['isRegex'] ?? 0) == 1, name: map['name'],
    pattern: map['pattern'], replacement: map['replacement'], source: map['source'],
  );

  Map<String, dynamic> toMap() => {'order': order, 'enabled': enabled ? 1 : 0, 'isRegex': isRegex ? 1 : 0, 'name': name, 'pattern': pattern, 'replacement': replacement, 'source': source};
  String apply(String input) => isRegex ? input.replaceAll(RegExp(pattern ?? ''), replacement ?? '') : input.replaceAll(pattern ?? '', replacement ?? '');
}
