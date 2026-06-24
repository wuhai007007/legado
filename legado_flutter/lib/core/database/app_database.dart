
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';









class AppDatabase {
  static const String dbName = "legado.db";
  static Database? _db;
  static AppDatabase? _instance;

  factory AppDatabase() {
    _instance ??= AppDatabase._();
    return _instance!;
  }
  AppDatabase._();

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path + '/' + dbName;
  }

  Future<Database> _initDatabase() async {
    final path = await _dbPath;
    return await openDatabase(
      path, version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        bookUrl TEXT PRIMARY KEY,
        tocUrl TEXT DEFAULT '',
        origin TEXT DEFAULT 'local',
        originName TEXT DEFAULT '',
        name TEXT DEFAULT '',
        author TEXT DEFAULT '',
        kind TEXT,
        customTag TEXT,
        coverUrl TEXT,
        customCoverUrl TEXT,
        intro TEXT,
        customIntro TEXT,
        charset TEXT,
        type INTEGER DEFAULT 0,
        group INTEGER DEFAULT 0,
        latestChapterTitle TEXT,
        latestChapterTime INTEGER DEFAULT 0,
        lastCheckTime INTEGER DEFAULT 0,
        lastCheckCount INTEGER DEFAULT 0,
        totalChapterNum INTEGER DEFAULT 0,
        durChapterTitle TEXT,
        durChapterIndex INTEGER DEFAULT 0,
        durChapterPos INTEGER DEFAULT 0,
        durChapterTime INTEGER DEFAULT 0,
        wordCount TEXT,
        canUpdate INTEGER DEFAULT 1,
        "order" INTEGER DEFAULT 0,
        originOrder INTEGER DEFAULT 0,
        variable TEXT,
        syncTime INTEGER DEFAULT 0
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_books_name_author ON books(name, author)');
    
    await db.execute('''
      CREATE TABLE book_sources (
        bookSourceUrl TEXT PRIMARY KEY,
        bookSourceName TEXT DEFAULT '',
        bookSourceGroup TEXT,
        bookSourceType INTEGER DEFAULT 0,
        bookUrlPattern TEXT,
        customOrder INTEGER DEFAULT 0,
        enabled INTEGER DEFAULT 1,
        enabledExplore INTEGER DEFAULT 1,
        jsLib TEXT,
        enabledCookieJar INTEGER DEFAULT 0,
        concurrentRate TEXT,
        header TEXT,
        loginUrl TEXT,
        loginUi TEXT,
        loginCheckJs TEXT,
        coverDecodeJs TEXT,
        bookSourceComment TEXT,
        variableComment TEXT,
        lastUpdateTime INTEGER DEFAULT 0,
        respondTime INTEGER DEFAULT 180000,
        weight INTEGER DEFAULT 0,
        exploreUrl TEXT,
        exploreScreen TEXT,
        searchUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE book_chapters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookUrl TEXT NOT NULL,
        url TEXT NOT NULL,
        title TEXT DEFAULT '',
        "index" INTEGER DEFAULT 0,
        tag TEXT,
        totalContentSize INTEGER DEFAULT 0
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_chapters_book ON book_chapters(bookUrl)');

    await db.execute('''
      CREATE TABLE book_groups (
        groupId INTEGER PRIMARY KEY AUTOINCREMENT,
        groupName TEXT DEFAULT '',
        "order" INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookName TEXT DEFAULT '',
        bookAuthor TEXT DEFAULT '',
        bookUrl TEXT,
        chapterIndex TEXT,
        chapterName TEXT,
        chapterPos INTEGER,
        content TEXT,
        createTime INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE replace_rules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        "order" INTEGER,
        enabled INTEGER DEFAULT 1,
        isRegex INTEGER DEFAULT 0,
        name TEXT,
        pattern TEXT,
        replacement TEXT,
        source TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE rss_sources (
        rssSourceUrl TEXT PRIMARY KEY,
        rssSourceName TEXT,
        rssSourceGroup TEXT,
        enabled INTEGER DEFAULT 1,
        customOrder INTEGER DEFAULT 0,
        header TEXT,
        jsLib TEXT,
        lastUpdateTime INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> close() async { (await database).close(); }
}


