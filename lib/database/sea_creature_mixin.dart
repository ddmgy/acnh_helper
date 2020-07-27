import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/sea_creature_table.dart';
import 'package:acnh_helper/model/sea_creature.dart';

mixin SeaCreatureMixin on DbProvider {
  Future<void> createSeaCreaturesTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${SeaCreatureTable.table}(
      ${SeaCreatureTable.colId} INTEGER PRIMARY KEY,
      ${SeaCreatureTable.colName} TEXT NOT NULL,
      ${SeaCreatureTable.colImageUri} TEXT NOT NULL,
      ${SeaCreatureTable.colThumbnailUri} TEXT NOT NULL,
      ${SeaCreatureTable.colSellPrice} INTEGER NOT NULL,
      ${SeaCreatureTable.colFound} INTEGER NOT NULL,
      ${SeaCreatureTable.colDonated} INTEGER NOT NULL,
      ${SeaCreatureTable.colMonthsAvailableNorthern} INTEGER NOT NULL,
      ${SeaCreatureTable.colMonthsAvailableSouthern} INTEGER NOT NULL,
      ${SeaCreatureTable.colTimesAvailable} INTEGER NOT NULL,
      ${SeaCreatureTable.colShadow} TEXT NOT NULL,
      ${SeaCreatureTable.colSpeed} TEXT NOT NULL
    )""");
  }

  Future<List<SeaCreature>> getSeaCreatures() async {
    final db = await database;
    final maps = await db.query(SeaCreatureTable.table);

    return List.generate(maps.length, (i) {
      return SeaCreature.fromMap(maps[i]);
    });
  }

  Future<int> insertSeaCreature(SeaCreature seaCreature) async {
    final db = await database;
    return await db.insert(
      SeaCreatureTable.table,
      seaCreature.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSeaCreature(SeaCreature seaCreature) async {
    final db = await database;
    return await db.update(
      SeaCreatureTable.table,
      seaCreature.toMap(),
      where: "${SeaCreatureTable.colId} = ?",
      whereArgs: [seaCreature.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteSeaCreature(SeaCreature seaCreature) async {
    final db = await database;
    return await db.delete(
      SeaCreatureTable.table,
      where: "${SeaCreatureTable.colId} = ?",
      whereArgs: [seaCreature.id],
    );
  }

  Future<int> deleteAllSeaCreatures() async {
    final db = await database;
    return await db.delete(SeaCreatureTable.table);
  }
}
