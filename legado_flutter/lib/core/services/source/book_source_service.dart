import 'dart:convert';
import '../../models/book_source.dart';
import '../../models/search_book.dart';
import '../../models/book.dart';
import '../../models/book_chapter.dart';
import '../http/http_helper.dart';
import 'package:html/parser.dart' as parser;

class BookSourceService {
  final BookSource source;

  BookSourceService(this.source);

  String _buildSearchUrl(String keyword, int page) {
    var url = source.searchUrl ?? '';
    url = url.replaceAll('{{key}}', Uri.encodeComponent(keyword));
    url = url.replaceAll('{{page}}', page.toString());
    url = url.replaceAll('{key}', Uri.encodeComponent(keyword));
    url = url.replaceAll('{page}', page.toString());
    return url;
  }

  Future<List<SearchBook>> search(String keyword, {int page = 1}) async {
    if (source.searchUrl == null || source.searchUrl!.isEmpty) return [];
    try {
      final url = _buildSearchUrl(keyword, page);
      final response = await HttpHelper.get(url, sourceHeader: source.header);
      if (!response.isSuccess || response.body.isEmpty) return [];

      final doc = parser.parse(response.body);
      final items = doc.querySelectorAll('li, .book-item, .result-item, tr, .search-list > div, .row, dl, .list-item');
      final books = <SearchBook>[];

      for (final item in items) {
        final nameEl = item.querySelector('a[href], h2, h3, .book-name, .name, .title, .book-title');
        final authorEl = item.querySelector('.author, .writer, small:last-of-type, .book-author');
        final linkEl = item.querySelector('a[href]');
        if (nameEl == null) continue;
        final name = nameEl.text.trim();
        if (name.isEmpty || name.length > 100) continue;
        final author = authorEl?.text.trim().replaceAll(RegExp(r'^[\/\s]*'), '') ?? '';
        final href = linkEl?.attributes['href'] ?? '';
        final bookUrl = href.isNotEmpty ? Uri.parse(url).resolve(href).toString() : '';
        if (bookUrl.isEmpty) continue;
        books.add(SearchBook(name: name, author: author, bookUrl: bookUrl,
            origin: source.bookSourceUrl, originName: source.bookSourceName));
        if (books.length >= 40) break;
      }

      if (books.isEmpty) {
        final regex = RegExp(r'<a[^>]*href="([^"]+)"[^>]*>\s*([^<]{2,80})\s*</a>');
        for (final match in regex.allMatches(response.body)) {
          final url = match.group(1) ?? '';
          final name = match.group(2)?.trim() ?? '';
          if (name.isNotEmpty && url.isNotEmpty && !url.startsWith('#') && !url.startsWith('javascript:') && name.length > 1) {
            books.add(SearchBook(name: name, author: '', bookUrl: Uri.parse(response.url).resolve(url).toString(),
                origin: source.bookSourceUrl, originName: source.bookSourceName));
          }
          if (books.length >= 30) break;
        }
      }
      return books;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getBookInfo(String bookUrl) async {
    try {
      final response = await HttpHelper.get(bookUrl, sourceHeader: source.header);
      if (!response.isSuccess) return {};
      final doc = parser.parse(response.body);
      final name = doc.querySelector('h1, .book-name, .name, h2')?.text.trim() ?? '';
      final author = doc.querySelector('.author, .writer, .book-author')?.text.trim().replaceAll(RegExp(r'^作者[：:]?\s*'), '') ?? '';
      final coverImg = doc.querySelector('img.cover, img[src*="cover"], .book-cover img');
      final coverUrl = coverImg?.attributes['src'] ?? '';
      final intro = doc.querySelector('#intro, .intro, .book-intro, .desc, .summary')?.text.trim() ?? '';
      final kind = doc.querySelector('.kind, .category, .tag')?.text.trim() ?? '';

      // Find TOC link
      var tocUrl = bookUrl;
      final tocLink = doc.querySelector('a[href*="chapter"], a[href*="catalog"], a[href*="list"], a[href*="index"], a[href*="toc"]');
      if (tocLink != null) {
        final href = tocLink.attributes['href'] ?? '';
        if (href.isNotEmpty) tocUrl = Uri.parse(bookUrl).resolve(href).toString();
      }

      return {
        'name': name, 'author': author, 'coverUrl': coverUrl,
        'intro': intro, 'kind': kind, 'tocUrl': tocUrl,
      };
    } catch (e) { return {}; }
  }

  Future<List<BookChapter>> getChapterList(String tocUrl) async {
    try {
      final response = await HttpHelper.get(tocUrl, sourceHeader: source.header);
      if (!response.isSuccess) return [];

      final doc = parser.parse(response.body);
      final linkEls = doc.querySelectorAll('a[href]');
      final chapters = <BookChapter>[];
      final seen = <String>{};
      int idx = 0;

      for (final el in linkEls) {
        final href = el.attributes['href'] ?? '';
        final title = el.text.trim();
        if (title.isEmpty || title.length > 200) continue;
        if (!href.contains('.') && !href.contains('/')) continue;
        if (href.startsWith('#') || href.startsWith('javascript:')) continue;

        final absUrl = Uri.parse(tocUrl).resolve(href).toString();
        if (seen.contains(absUrl)) continue;
        seen.add(absUrl);

        chapters.add(BookChapter(bookUrl: '', url: absUrl, title: title, index: idx++));
        if (chapters.length >= 5000) break;
      }
      return chapters;
    } catch (e) { return []; }
  }

  Future<String> getChapterContent(String chapterUrl) async {
    try {
      final response = await HttpHelper.get(chapterUrl, sourceHeader: source.header);
      if (!response.isSuccess) return '';
      final doc = parser.parse(response.body);
      var content = '';

      // Try common content selectors
      final contentEl = doc.querySelector('#content, .content, .chapter-content, .read-content, .txt, #chaptercontent, .chapter_content, .text');
      if (contentEl != null) {
        content = contentEl.text.trim();
      } else {
        // Fallback: get all text from body
        content = doc.body?.text.trim() ?? '';
        // Remove header/footer noise
        final lines = content.split('\n').where((l) => l.trim().length > 5).toList();
        content = lines.join('\n');
      }

      // Apply replace rules - strip ads
      content = content.replaceAll(RegExp(r'手机.*?阅读|一秒记住.*?\.(com|net|org)|章节错误.*?举报|天才一秒记住|推荐使用.*?阅读|请收藏本站|本站最新地址|高速文字.*?首发|最新章节.*?网址'), '');
      content = content.replaceAll(RegExp(r'http[s]?://\S+'), '');
      content = content.trim();

      return content;
    } catch (e) { return ''; }
  }
}
