import 'dart:convert';
import 'package:http/http.dart' as http;

class StrResponse {
  final String body;
  final int statusCode;
  final Map<String, String> headers;
  final String url;

  StrResponse({required this.body, required this.statusCode, required this.headers, required this.url});
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isJson => body.trim().startsWith('{') || body.trim().startsWith('[');
}

class HttpHelper {
  static const int connectTimeout = 15000;
  static const int readTimeout = 30000;
  static http.Client? _client;

  static http.Client get client => _client ??= http.Client();

  static Map<String, String> baseHeaders(Map<String, String>? extra) {
    final h = <String, String>{
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Language': 'zh-CN,zh;q=0.9',
    };
    if (extra != null) h.addAll(extra);
    return h;
  }

  static Map<String, String> parseHeaderJson(String? headerJson) {
    if (headerJson == null || headerJson.isEmpty) return {};
    try {
      final map = jsonDecode(headerJson) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) { return {}; }
  }

  static String encodeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.isNotEmpty) return url;
    } catch (_) {}
    return Uri.encodeFull(url);
  }

  static Future<StrResponse> get(String url, {Map<String, String>? headers, String? sourceHeader}) async {
    final allHeaders = baseHeaders(headers);
    if (sourceHeader != null) allHeaders.addAll(parseHeaderJson(sourceHeader));
    try {
      final uri = Uri.parse(encodeUrl(url));
      final response = await client.get(uri, headers: allHeaders).timeout(Duration(milliseconds: readTimeout));
      final body = utf8.decode(response.bodyBytes);
      return StrResponse(body: body, statusCode: response.statusCode, headers: response.headers.map((k, v) => MapEntry(k, v)), url: response.request?.url.toString() ?? url);
    } catch (e) {
      throw Exception("HTTP GET failed: $e");
    }
  }

  static Future<StrResponse> post(String url, {Map<String, String>? headers, dynamic body, String? sourceHeader}) async {
    final allHeaders = baseHeaders(headers);
    allHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
    if (sourceHeader != null) allHeaders.addAll(parseHeaderJson(sourceHeader));
    try {
      final uri = Uri.parse(encodeUrl(url));
      final response = await client.post(uri, headers: allHeaders, body: body).timeout(Duration(milliseconds: readTimeout));
      final bodyStr = utf8.decode(response.bodyBytes);
      return StrResponse(body: bodyStr, statusCode: response.statusCode, headers: response.headers.map((k, v) => MapEntry(k, v)), url: response.request?.url.toString() ?? url);
    } catch (e) {
      throw Exception("HTTP POST failed: $e");
    }
  }
}

