import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../models/book_source.dart';

class HttpHelper {
  static const int connectTimeout = 15000;
  static const int readTimeout = 60000;
  static http.Client? _client;

  static http.Client get client {
    _client ??= http.Client();
    return _client!;
  }

  static Map<String, String> getDefaultHeaders() {
    return {
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    };
  }

  static Future<StrResponse> get(String url, {Map<String, String>? headers, BookSource? source}) async {
    try {
      final allHeaders = {...getDefaultHeaders(), ...?headers};
      if (source?.header != null) {
        final sourceHeaders = _parseHeader(source!.header!);
        allHeaders.addAll(sourceHeaders);
      }
      final uri = Uri.parse(url);
      final response = await client.get(uri, headers: allHeaders).timeout(Duration(milliseconds: readTimeout));
      final body = utf8.decode(response.bodyBytes);
      return StrResponse(
        body: body,
        statusCode: response.statusCode,
        headers: response.headers,
        url: response.request?.url.toString() ?? url,
      );
    } catch (e) {
      throw HttpException('GET $url failed: $e');
    }
  }

  static Future<StrResponse> post(String url, {Map<String, String>? headers, dynamic body, BookSource? source}) async {
    try {
      final allHeaders = {...getDefaultHeaders(), ...?headers, 'Content-Type': 'application/x-www-form-urlencoded'};
      if (source?.header != null) {
        allHeaders.addAll(_parseHeader(source!.header!));
      }
      final uri = Uri.parse(url);
      final response = await client.post(uri, headers: allHeaders, body: body).timeout(Duration(milliseconds: readTimeout));
      final bodyStr = utf8.decode(response.bodyBytes);
      return StrResponse(
        body: bodyStr, statusCode: response.statusCode,
        headers: response.headers, url: response.request?.url.toString() ?? url,
      );
    } catch (e) {
      throw HttpException('POST $url failed: $e');
    }
  }

  static Uint8List? decodeBase64Cover(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      final stripped = data.replaceFirst(RegExp(r'^data:image/\w+;base64,'), '');
      return base64Decode(stripped);
    } catch (_) {
      return null;
    }
  }

  static Map<String, String> _parseHeader(String header) {
    try {
      final map = <String, String>{};
      final json = jsonDecode(header);
      if (json is Map) {
        json.forEach((k, v) => map[k.toString()] = v.toString());
      }
      return map;
    } catch (_) {
      return {};
    }
  }
}

class StrResponse {
  final String body;
  final int statusCode;
  final Map<String, String> headers;
  final String url;

  StrResponse({required this.body, required this.statusCode, required this.headers, required this.url});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  String? get contentType => headers['content-type'];
  bool get isJson => contentType?.contains('json') ?? (body.trim().startsWith('{') || body.trim().startsWith('['));
}
