import 'package:sqflite/sqflite.dart';
import '../../models/book.dart';
import '../app_database.dart';

class BookDao {
  final AppDatabase _db = AppDatabase();

  Future<int> insert(Book book) async {
    final db = await _db.database;
    return await db.insert('books', book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(Book book) async {
    final db = await _db.database;
    return await db.update('books', book.toMap(), where: 'bookUrl = ?', whereArgs: [book.bookUrl]);
  }

  Future<int> delete(Book book) async {
    final db = await _db.database;
    return await db.delete('books', where: 'bookUrl = ?', whereArgs: [book.bookUrl]);
  }

  Future<Book?> getByUrl(String bookUrl) async {
    final db = await _db.database;
    final maps = await db.query('books', where: 'bookUrl = ?', whereArgs: [bookUrl]);
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }

  Future<List<Book>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('books', orderBy: '"order" ASC, latestChapterTime DESC');
    return maps.map((m) => Book.fromMap(m)).toList();
  }

  Future<List<Book>> getByGroup(int group) async {
    final db = await _db.database;
    final maps = await db.query('books', where: '"group" = ?', whereArgs: [group], orderBy: '"order" ASC');
    return maps.map((m) => Book.fromMap(m)).toList();
  }

  Future<bool> has(String bookUrl) async {
    final db = await _db.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM books WHERE bookUrl = ?', [bookUrl]));
    return (count ?? 0) > 0;
  }

  Future<int> count() async {
    final db = await _db.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM books')) ?? 0;
  }

  Future<void> deleteAll() async {
    final db = await _db.database;
    await db.delete('books');
  }
}
