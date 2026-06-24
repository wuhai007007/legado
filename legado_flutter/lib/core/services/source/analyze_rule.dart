import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class AnalyzeRule {
  String? _content;
  bool _isJson = false;
  Map<String, dynamic>? _jsonData;
  dynamic _htmlDoc;

  AnalyzeRule(this._content, {bool treatAsJson = false}) {
    if (_content == null) return;
    final trimmed = _content!.trim();
    _isJson = treatAsJson || trimmed.startsWith('{') || trimmed.startsWith('[');
    var isXml = trimmed.startsWith('<') && trimmed.endsWith('>');
    
    if (_isJson) {
      try { _jsonData = jsonDecode(_content!); } catch (_) { _isJson = false; }
    }
    if (isXml || (!_isJson && isXml)) {
      try { _htmlDoc = html_parser.parse(_content!); } catch (_) { }
    }
  }

  List<String>? getStringList(String rule, {bool isUrl = false}) {
    if (rule.isEmpty) return null;
    if (rule.startsWith('@js:')) return null;
    if (rule.startsWith('//') || rule.startsWith('./') || rule.startsWith('/')) {
      return _getByXPath(rule);
    }
    if (rule.startsWith('\$.')) {
      return _getByJsonPath(rule);
    }
    if (rule.startsWith('css:')) {
      return _getByCssSelector(rule.substring(4));
    }
    if (rule.contains('&&')) {
      return _getByMultiRule(rule);
    }
    return _getByRegex(rule);
  }

  String? getString(String rule, {bool isUrl = false}) {
    final list = getStringList(rule, isUrl: isUrl);
    if (list != null && list.isNotEmpty) return list.first;
    return null;
  }

  List<String>? _getByXPath(String xpath) {
    if (_htmlDoc == null) return null;
    try {
      final results = <String>[];
      final tag = xpath.split('/').last;
      final elements = _htmlDoc!.querySelectorAll(tag.isEmpty ? '*' : tag);
      for (final el in elements) { results.add(el.text.trim()); }
      return results.isNotEmpty ? results : null;
    } catch (_) { return null; }
  }

  List<String>? _getByJsonPath(String path) {
    if (_jsonData == null) return null;
    try {
      final keys = path.replaceFirst('\$.', '').split('.');
      dynamic current = _jsonData;
      for (final key in keys) {
        if (current is Map) { current = current[key]; }
        else if (current is List) {
          final idx = int.tryParse(key);
          if (idx != null && idx < current.length) current = current[idx];
          else return null;
        } else return null;
      }
      if (current is List) return current.map((e) => e.toString()).toList();
      if (current != null) return [current.toString()];
      return null;
    } catch (_) { return null; }
  }

  List<String>? _getByCssSelector(String selector) {
    if (_htmlDoc == null) return null;
    try {
      final elements = _htmlDoc!.querySelectorAll(selector);
      return elements.map((e) => e.text.trim()).toList();
    } catch (_) { return null; }
  }

  List<String>? _getByRegex(String rule) {
    if (_content == null) return null;
    try {
      final regex = RegExp(rule, multiLine: true, dotAll: true);
      final matches = regex.allMatches(_content!);
      return matches.map((m) => m.groupCount > 0 ? m.group(1)!.trim() : m.group(0)!.trim()).toList();
    } catch (_) { return null; }
  }

  List<String>? _getByMultiRule(String rule) {
    if (_htmlDoc == null) return null;
    try {
      final parts = rule.split('&&');
      var elements = _htmlDoc!.querySelectorAll(parts.first.trim());
      for (int i = 1; i < parts.length; i++) {
        final p = parts[i].trim();
        elements = elements.map((e) => e.querySelectorAll(p)).expand((x) => x).toList();
      }
      return elements.map((e) => e.text.trim()).toList();
    } catch (_) { return null; }
  }
}
