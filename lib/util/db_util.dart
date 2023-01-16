import 'package:dia_de_sexta/app_routes/tabelas_db.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class TabelasDB {
  static const String tbDefinicoes =
      "CREATE TABLE ${NomeTabelaDB.definicoesJogo} (id INTEGER PRIMARY KEY AUTOINCREMENT, numeroJogadores INTEGER)";
  static const String tbPlacar =
      "CREATE TABLE ${NomeTabelaDB.placar} (id INTEGER PRIMARY KEY AUTOINCREMENT, grupo_1 INTEGER, grupo_2 INTEGER, placar1 INTEGER, placar2 INTEGER, data TEXT, tempoJogo TEXT);";
  static const String tbJogadores =
      "CREATE TABLE ${NomeTabelaDB.jogadores} (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT UNIQUE, possuiTime INTEGER);";
  static const String tbTime =
      "CREATE TABLE ${NomeTabelaDB.time} (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, qtdParticipantes INTEGER);";
  static const String tbGrupos =
      "CREATE TABLE ${NomeTabelaDB.grupos} (id INTEGER PRIMARY KEY AUTOINCREMENT, idTime INTEGER, idJogador INTEGER);";
  static const String tbNomeJogadoresGrupo =
      "CREATE TABLE ${NomeTabelaDB.nomeJogadoresGrupo} (id INTEGER PRIMARY KEY AUTOINCREMENT, idPlacar INTEGER, nomeJogador TEXT, idTime INTEGER)";
}

class DbUtil {
  static Future<void> criarTabelasBanco(sql.Database db, int version) async {
    List<String> queryes = [
      TabelasDB.tbDefinicoes,
      TabelasDB.tbPlacar,
      TabelasDB.tbJogadores,
      TabelasDB.tbTime,
      TabelasDB.tbGrupos,
      TabelasDB.tbNomeJogadoresGrupo,
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
      String tabela, int chave, Map<String, dynamic> data) async {
    final db = await DbUtil.database();
    await db.update(tabela, data, where: 'id = ?', whereArgs: [chave]);
  }
}
