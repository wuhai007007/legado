import 'package:sqflite/sqflite.dart';
import '../../models/book_source.dart';
import '../app_database.dart';

class BookSourceDao {
  final AppDatabase _db = AppDatabase();

  Future<int> insert(BookSource source) async {
    final db = await _db.database;
    return await db.insert('book_sources', source.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(BookSource source) async {
    final db = await _db.database;
    return await db.update('book_sources', source.toMap(), where: 'bookSourceUrl = ?', whereArgs: [source.bookSourceUrl]);
  }

  Future<int> delete(BookSource source) async {
    final db = await _db.database;
    return await db.delete('book_sources', where: 'bookSourceUrl = ?', whereArgs: [source.bookSourceUrl]);
  }

  Future<BookSource?> getByUrl(String url) async {
    final db = await _db.database;
    final maps = await db.query('book_sources', where: 'bookSourceUrl = ?', whereArgs: [url]);
    if (maps.isEmpty) return null;
    return BookSource.fromMap(maps.first);
  }

  Future<List<BookSource>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('book_sources', orderBy: 'customOrder ASC, lastUpdateTime DESC');
    return maps.map((m) => BookSource.fromMap(m)).toList();
  }

  Future<List<BookSource>> getEnabled() async {
    final db = await _db.database;
    final maps = await db.query('book_sources', where: 'enabled = 1');
    return maps.map((m) => BookSource.fromMap(m)).toList();
  }

  Future<int> count() async {
    final db = await _db.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM book_sources')) ?? 0;
  }

  Future<void> deleteAll() async {
    final db = await _db.database;
    await db.delete('book_sources');
  }
}
