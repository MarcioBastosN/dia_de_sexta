import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class TabelasDB {
  static const String tbPlacar =
      "CREATE TABLE tbPlacar (id INTEGER PRIMARY KEY AUTOINCREMENT, grupo_1 TEXT, grupo_2 TEXT, placar1 INTEGER, placar2 INTEGER, data TEXT, tempoJogo TEXT);";
  static const String tbJogadores =
      "CREATE TABLE tbJogadores (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT);";
}

class DbUtil {
  static Future<void> criarTabelasBanco(sql.Database db, int version) async {
    List<String> queryes = [
      TabelasDB.tbPlacar,
      TabelasDB.tbJogadores,
    ];

    for (String query in queryes) {
      await db.execute(query);
    }
  }

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'AppVolei.db'),
      onCreate: (db, version) => criarTabelasBanco(db, version),
      version: 2,
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

  static Future<void> update(
      String table, int chave, Map<String, dynamic> data) async {
    final db = await DbUtil.database();
    await db.update(table, data, where: 'id = ?', whereArgs: [chave]);
  }
}
