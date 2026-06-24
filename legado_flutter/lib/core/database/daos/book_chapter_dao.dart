import "package:sqflite/sqflite.dart";
import "../../models/book_chapter.dart";
import "../app_database.dart";

class BookChapterDao {
  final AppDatabase _db = AppDatabase();
  Future<int> bulkInsert(List<BookChapter> chapters) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final ch in chapters) { batch.insert('book_chapters', ch.toMap(), conflictAlgorithm: ConflictAlgorithm.replace); }
    await batch.commit(noResult: true);
    return chapters.length;
  }
  Future<List<BookChapter>> getByBookUrl(String bookUrl) async {
    final db = await _db.database;
    return (await db.query('book_chapters', where: 'bookUrl = ?', whereArgs: [bookUrl], orderBy: '"index" ASC')).map((m) => BookChapter.fromMap(m)).toList();
  }
  Future<void> deleteByBookUrl(String bookUrl) async {
    final db = await _db.database;
    await db.delete('book_chapters', where: 'bookUrl = ?', whereArgs: [bookUrl]);
  }
  Future<int> getCount(String bookUrl) async {
    final db = await _db.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM book_chapters WHERE bookUrl = ?', [bookUrl])) ?? 0;
  }
}
