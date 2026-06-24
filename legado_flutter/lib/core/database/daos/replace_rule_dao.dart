import "package:sqflite/sqflite.dart";
import "../../models/replace_rule.dart";
import "../app_database.dart";

class ReplaceRuleDao {
  final AppDatabase _db = AppDatabase();
  Future<int> insert(ReplaceRule rule) async {
    final db = await _db.database;
    return await db.insert('replace_rules', rule.toMap());
  }
  Future<int> update(ReplaceRule rule) async {
    final db = await _db.database;
    return await db.update('replace_rules', rule.toMap(), where: 'id = ?', whereArgs: [rule.id]);
  }
  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('replace_rules', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<ReplaceRule>> getAll() async {
    final db = await _db.database;
    return (await db.query('replace_rules', orderBy: '"order" ASC')).map((m) => ReplaceRule.fromMap(m)).toList();
  }
  Future<List<ReplaceRule>> getEnabled() async {
    final db = await _db.database;
    return (await db.query('replace_rules', where: 'enabled = 1', orderBy: '"order" ASC')).map((m) => ReplaceRule.fromMap(m)).toList();
  }
}
