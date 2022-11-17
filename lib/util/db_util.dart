import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'AppVolei.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tb_placar (id INTEGER PRIMARY KEY AUTOINCREMENT, grupo_1 TEXT, grupo_2 TEXT, placar1 INTEGER, placar2 INTEGER, data TEXT, tempoJogo TEXT);');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, int? id) async {
    final db = await DbUtil.database();
    await db.rawDelete(
      "DELETE FROM $table wHERE id = ?",
      [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String tabela) async {
    final db = await DbUtil.database();
    return db.query(tabela);
  }
}
