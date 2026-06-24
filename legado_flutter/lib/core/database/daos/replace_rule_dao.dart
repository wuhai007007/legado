import 'package:sqflite/sqflite.dart';
import '../../models/replace_rule.dart';
import '../app_database.dart';

class ReplaceRuleDao {
  final AppDatabase _db = AppDatabase();

  Future<int> insert(ReplaceRule rule) async {
    final db = await _db.database;
    return await db.insert('replace_rules', rule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ReplaceRule>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('replace_rules', orderBy: '"order" ASC');
    return maps.map((m) => ReplaceRule.fromMap(m)).toList();
  }

  Future<List<ReplaceRule>> getEnabled() async {
    final db = await _db.database;
    final maps = await db.query('replace_rules', where: 'enabled = 1', orderBy: '"order" ASC');
    return maps.map((m) => ReplaceRule.fromMap(m)).toList();
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('replace_rules', where: 'id = ?', whereArgs: [id]);
  }
}
