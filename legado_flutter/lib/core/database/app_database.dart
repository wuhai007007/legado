import "package:sqflite/sqflite.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

class AppDatabase {
  static const String dbName = "legado.db";
  static const int dbVersion = 1;
  static Database? _db;
  static AppDatabase? _instance;

  factory AppDatabase() { _instance ??= AppDatabase._(); return _instance!; }
  AppDatabase._();

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, dbName);
  }

  Future<Database> _initDatabase() async {
    final path = await _dbPath;
    return await openDatabase(path, version: dbVersion,
        onCreate: _onCreate, singleInstance: true);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE books (bookUrl TEXT PRIMARY KEY, tocUrl TEXT DEFAULT '', origin TEXT DEFAULT 'local', originName TEXT DEFAULT '', name TEXT DEFAULT '', author TEXT DEFAULT '', kind TEXT, customTag TEXT, coverUrl TEXT, customCoverUrl TEXT, intro TEXT, customIntro TEXT, charset TEXT, type INTEGER DEFAULT 0, \"group\" INTEGER DEFAULT 0, latestChapterTitle TEXT, latestChapterTime INTEGER DEFAULT 0, lastCheckTime INTEGER DEFAULT 0, lastCheckCount INTEGER DEFAULT 0, totalChapterNum INTEGER DEFAULT 0, durChapterTitle TEXT, durChapterIndex INTEGER DEFAULT 0, durChapterPos INTEGER DEFAULT 0, durChapterTime INTEGER DEFAULT 0, wordCount TEXT, canUpdate INTEGER DEFAULT 1, \"order\" INTEGER DEFAULT 0, originOrder INTEGER DEFAULT 0, variable TEXT, syncTime INTEGER DEFAULT 0)");
    await db.execute("CREATE INDEX idx_books_name ON books(name)");
    await db.execute("CREATE TABLE book_sources (bookSourceUrl TEXT PRIMARY KEY, bookSourceName TEXT DEFAULT '', bookSourceGroup TEXT, bookSourceType INTEGER DEFAULT 0, bookUrlPattern TEXT, customOrder INTEGER DEFAULT 0, enabled INTEGER DEFAULT 1, enabledExplore INTEGER DEFAULT 1, jsLib TEXT, enabledCookieJar INTEGER DEFAULT 0, concurrentRate TEXT, header TEXT, loginUrl TEXT, loginUi TEXT, loginCheckJs TEXT, coverDecodeJs TEXT, bookSourceComment TEXT, variableComment TEXT, lastUpdateTime INTEGER DEFAULT 0, respondTime INTEGER DEFAULT 180000, weight INTEGER DEFAULT 0, exploreUrl TEXT, exploreScreen TEXT, searchUrl TEXT)");
    await db.execute("CREATE TABLE book_chapters (id INTEGER PRIMARY KEY AUTOINCREMENT, bookUrl TEXT NOT NULL, url TEXT NOT NULL, title TEXT DEFAULT '', \"index\" INTEGER DEFAULT 0, tag TEXT, totalContentSize INTEGER DEFAULT 0)");
    await db.execute("CREATE INDEX idx_chapters_book ON book_chapters(bookUrl)");
    await db.execute("CREATE UNIQUE INDEX idx_chapters_url ON book_chapters(bookUrl, url)");
    await db.execute("CREATE TABLE bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT, bookName TEXT DEFAULT '', bookAuthor TEXT DEFAULT '', bookUrl TEXT, chapterIndex INTEGER DEFAULT 0, chapterName TEXT, chapterPos INTEGER DEFAULT 0, content TEXT, createTime INTEGER DEFAULT 0)");
    await db.execute("CREATE TABLE replace_rules (id INTEGER PRIMARY KEY AUTOINCREMENT, \"order\" INTEGER DEFAULT 0, enabled INTEGER DEFAULT 1, isRegex INTEGER DEFAULT 0, name TEXT, pattern TEXT, replacement TEXT, source TEXT)");
    await db.execute("CREATE TABLE rss_sources (rssSourceUrl TEXT PRIMARY KEY, rssSourceName TEXT DEFAULT '', rssSourceGroup TEXT, enabled INTEGER DEFAULT 1, customOrder INTEGER DEFAULT 0, header TEXT, jsLib TEXT, lastUpdateTime INTEGER DEFAULT 0)");
    await db.execute("CREATE TABLE rss_articles (id INTEGER PRIMARY KEY AUTOINCREMENT, rssSourceUrl TEXT NOT NULL, title TEXT, link TEXT, description TEXT, author TEXT, pubDate TEXT, read INTEGER DEFAULT 0, star INTEGER DEFAULT 0)");
    await db.execute("CREATE TABLE cookies (domain TEXT PRIMARY KEY, cookie TEXT)");
    await db.execute("CREATE TABLE search_history (id INTEGER PRIMARY KEY AUTOINCREMENT, keyword TEXT, time INTEGER DEFAULT 0)");
  }
  Future<void> close() async { final db = await database; await db.close(); _db = null; }
}
