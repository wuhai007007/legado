import '../../models/book_source.dart';
import '../http/http_helper.dart';
import '../../models/search_book.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class BookSourceService {
  final BookSource source;

  BookSourceService(this.source);

  Future<List<SearchBook>> search(String keyword, {int page = 1}) async {
    if (source.searchUrl == null || source.searchUrl!.isEmpty) return [];
    final searchUrl = _buildSearchUrl(keyword, page);
    final response = await HttpHelper.get(searchUrl, source: source);
    if (!response.isSuccess || response.body.isEmpty) return [];
    return _parseBookList(response.body, searchUrl);
  }

  String _buildSearchUrl(String keyword, int page) {
    return source.searchUrl!
        .replaceAll('{{key}}', Uri.encodeComponent(keyword))
        .replaceAll('{{page}}', page.toString())
        .replaceAll('{key}', Uri.encodeComponent(keyword))
        .replaceAll('{page}', page.toString());
  }

  List<SearchBook> _parseBookList(String html, String baseUrl) {
    final doc = html_parser.parse(html);
    final books = <SearchBook>[];
    final items = doc.querySelectorAll('li, .book-item, .result-item, tr, .search-list > div, .row');
    for (final item in items) {
      final nameEl = item.querySelector('a[href], h2, h3, .book-name, .name, .title, .book-title');
      final authorEl = item.querySelector('.author, .writer, small:last-of-type, .book-author');
      final linkEl = item.querySelector('a[href]');
      if (nameEl == null) continue;
      final name = nameEl.text.trim();
      if (name.isEmpty) continue;
      final author = authorEl?.text.trim().replaceAll(RegExp(r'^[\/\s]*'), '') ?? '';
      final href = linkEl?.attributes['href'] ?? '';
      final bookUrl = href.isNotEmpty ? Uri.parse(baseUrl).resolve(href).toString() : '';
      books.add(SearchBook(name: name, author: author, bookUrl: bookUrl,
          origin: source.bookSourceUrl, originName: source.bookSourceName));
      if (books.length >= 30) break;
    }
    if (books.isEmpty) {
      final regex = RegExp(r'<a[^>]*href="([^"]*)"[^>]*>\s*([^<]{2,80})\s*</a>');
      for (final match in regex.allMatches(html)) {
        final url = match.group(1) ?? '';
        final name = match.group(2)?.trim() ?? '';
        if (name.isNotEmpty && url.isNotEmpty && !url.startsWith('#') && !url.startsWith('javascript:') && name.length > 1) {
          books.add(SearchBook(name: name, author: '', bookUrl: Uri.parse(baseUrl).resolve(url).toString(),
              origin: source.bookSourceUrl, originName: source.bookSourceName));
        }
        if (books.length >= 20) break;
      }
    }
    return books;
  }
}
