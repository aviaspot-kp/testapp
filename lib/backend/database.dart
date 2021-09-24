import 'package:fetchingapp/backend/sql_queries.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDB() async {
  return openDatabase(join(await getDatabasesPath(), 'cache_database.db'),
      onCreate: (db, version) {
    return db.execute(Queries().createCacheTable);
  }, version: 1);
}

Future insertSQLite({required Map<String, dynamic> item}) async {
  final db = await initializeDB();
  db.insert('cache', item);
}

Future updateSQLite({required Map<String, dynamic> item}) async {
  final db = await initializeDB();
  db.update('cache', item, where: 'doc_id = ?', whereArgs: [item['doc_id']]);
}

Future deleteSQLite({required Map<String, dynamic> item}) async {
  final db = await initializeDB();
  db.delete('cache', where: 'doc_id = ?', whereArgs: [item['doc_id']]);
}

Future insertBatchSQLite({required List<Map<String, dynamic>> list}) async {
  final db = await initializeDB();
  final batch = db.batch();
  for (var item in list) {
    batch.insert('cache', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  await batch.commit(noResult: true);
}

Future cleanDB() async {
  final db = await initializeDB();
  db.execute(Queries().dropCacheTable);
  db.execute(Queries().createCacheTable);
}


