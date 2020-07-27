import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/fossil_table.dart';
import 'package:acnh_helper/model/fossil.dart';

mixin FossilMixin on DbProvider {
  Future<void> createFossilsTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${FossilTable.table}(
      ${FossilTable.colId} INTEGER PRIMARY KEY,
      ${FossilTable.colName} TEXT NOT NULL,
      ${FossilTable.colImageUri} TEXT NOT NULL,
      ${FossilTable.colThumbnailUri} TEXT NOT NULL,
      ${FossilTable.colSellPrice} INTEGER NOT NULL,
      ${FossilTable.colFound} INTEGER NOT NULL,
      ${FossilTable.colDonated} INTEGER NOT NULL
    )""");
  }

  Future<List<Fossil>> getFossils() async {
    final db = await database;
    final maps = await db.query(FossilTable.table);

    return List.generate(maps.length, (i) {
      return Fossil.fromMap(maps[i]);
    });
  }

  Future<int> insertFossil(Fossil fossil) async {
    final db = await database;
    return await db.insert(
      FossilTable.table,
      fossil.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFossil(Fossil fossil) async {
    final db = await database;
    return await db.update(
      FossilTable.table,
      fossil.toMap(),
      where: "${FossilTable.colId} = ?",
      whereArgs: [fossil.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteFossil(Fossil fossil) async {
    final db = await database;
    return await db.delete(
      FossilTable.table,
      where: "${FossilTable.colId} = ?",
      whereArgs: [fossil.id],
    );
  }

  Future<int> deleteAllFossils() async {
    final db = await database;
    return await db.delete(FossilTable.table);
  }
}
