import 'package:sqflite/sqflite.dart';
import '../../models/book_chapter.dart';
import '../app_database.dart';

class BookChapterDao {
  final AppDatabase _db = AppDatabase();

  Future<int> bulkInsert(List<BookChapter> chapters) async {
    final db = await _db.database;
    int count = 0;
    final batch = db.batch();
    for (final ch in chapters) {
      batch.insert('book_chapters', ch.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      count++;
    }
    await batch.commit(noResult: true);
    return count;
  }

  Future<List<BookChapter>> getByBookUrl(String bookUrl) async {
    final db = await _db.database;
    final maps = await db.query('book_chapters', where: 'bookUrl = ?', whereArgs: [bookUrl], orderBy: '"index" ASC');
    return maps.map((m) => BookChapter.fromMap(m)).toList();
  }

  Future<void> deleteByBookUrl(String bookUrl) async {
    final db = await _db.database;
    await db.delete('book_chapters', where: 'bookUrl = ?', whereArgs: [bookUrl]);
  }
}
