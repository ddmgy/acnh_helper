import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/art_table.dart';
import 'package:acnh_helper/model/art.dart';

mixin ArtMixin on DbProvider {
  Future<void> createArtsTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${ArtTable.table}(
      ${ArtTable.colId} INTEGER PRIMARY KEY,
      ${ArtTable.colName} TEXT NOT NULL,
      ${ArtTable.colHasFake} INTEGER NOT NULL,
      ${ArtTable.colBuyPrice} INTEGER NOT NULL,
      ${ArtTable.colSellPrice} INTEGER NOT NULL,
      ${ArtTable.colImageUri} TEXT NOT NULL,
      ${ArtTable.colThumbnailUri} TEXT NOT NULL,
      ${ArtTable.colFound} INTEGER NOT NULL,
      ${ArtTable.colDonated} INTEGER NOT NULL
    )""");
  }

  Future<List<Art>> getArts() async {
    final db = await database;
    final maps = await db.query(ArtTable.table);

    return List.generate(maps.length, (i) {
      return Art.fromMap(maps[i]);
    });
  }

  Future<int> insertArt(Art art) async {
    final db = await database;
    return await db.insert(
      ArtTable.table,
      art.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateArt(Art art) async {
    final db = await database;
    return await db.update(
      ArtTable.table,
      art.toMap(),
      where: "${ArtTable.colId} = ?",
      whereArgs: [art.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteArt(Art art) async {
    final db = await database;
    return await db.delete(
      ArtTable.table,
      where: "${ArtTable.colId} = ?",
      whereArgs: [art.id],
    );
  }

  Future<int> deleteAllArts() async {
    final db = await database;
    return await db.delete(ArtTable.table);
  }
}
