import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/fish_table.dart';
import 'package:acnh_helper/model/fish.dart';

mixin FishMixin on DbProvider {
  Future<void> createFishesTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${FishTable.table}(
      ${FishTable.colId} INTEGER PRIMARY KEY,
      ${FishTable.colName} TEXT NOT NULL,
      ${FishTable.colImageUri} TEXT NOT NULL,
      ${FishTable.colThumbnailUri} TEXT NOT NULL,
      ${FishTable.colSellPrice} INTEGER NOT NULL,
      ${FishTable.colFound} INTEGER NOT NULL,
      ${FishTable.colDonated} INTEGER NOT NULL,
      ${FishTable.colMonthsAvailableNorthern} INTEGER NOT NULL,
      ${FishTable.colMonthsAvailableSouthern} INTEGER NOT NULL,
      ${FishTable.colTimesAvailable} INTEGER NOT NULL,
      ${FishTable.colLocation} TEXT NOT NULL,
      ${FishTable.colShadow} TEXT NOT NULL
    )""");
  }

  Future<List<Fish>> getFishes() async {
    final db = await database;
    final maps = await db.query(FishTable.table);

    return List.generate(maps.length, (i) {
      return Fish.fromMap(maps[i]);
    });
  }

  Future<int> insertFish(Fish fish) async {
    final db = await database;
    return await db.insert(
      FishTable.table,
      fish.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFish(Fish fish) async {
    final db = await database;
    return await db.update(
      FishTable.table,
      fish.toMap(),
      where: "${FishTable.colId} = ?",
      whereArgs: [fish.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteFish(Fish fish) async {
    final db = await database;
    return await db.delete(
      FishTable.table,
      where: "${FishTable.colId} = ?",
      whereArgs: [fish.id],
    );
  }

  Future<int> deleteAllFishes() async {
    final db = await database;
    return await db.delete(FishTable.table);
  }
}
