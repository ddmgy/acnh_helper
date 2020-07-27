import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/villager_table.dart';
import 'package:acnh_helper/model/villager.dart';

mixin VillagerMixin on DbProvider {
  Future<void> createVillagersTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${VillagerTable.table}(
      ${VillagerTable.colId} INTEGER PRIMARY KEY,
      ${VillagerTable.colName} TEXT NOT NULL,
      ${VillagerTable.colImageUri} TEXT NOT NULL,
      ${VillagerTable.colThumbnailUri} TEXT NOT NULL,
      ${VillagerTable.colPersonality} TEXT NOT NULL,
      ${VillagerTable.colBirthday} TEXT NOT NULL,
      ${VillagerTable.colBirthdayString} TEXT NOT NULL,
      ${VillagerTable.colSpecies} TEXT NOT NULL,
      ${VillagerTable.colGender} TEXT NOT NULL,
      ${VillagerTable.colIsNeighbor} INTEGER NOT NULL
    )""");
  }

  Future<List<Villager>> getVillagers() async {
    final db = await database;
    final maps = await db.query(VillagerTable.table);

    return List.generate(maps.length, (i) {
      return Villager.fromMap(maps[i]);
    });
  }

  Future<int> insertVillager(Villager villager) async {
    final db = await database;
    return await db.insert(
      VillagerTable.table,
      villager.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateVillager(Villager villager) async {
    final db = await database;
    return await db.update(
      VillagerTable.table,
      villager.toMap(),
      where: "${VillagerTable.colId} = ?",
      whereArgs: [villager.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteVillager(Villager villager) async {
    final db = await database;
    return await db.delete(
      VillagerTable.table,
      where: "${VillagerTable.colId} = ?",
      whereArgs: [villager.id],
    );
  }

  Future<int> deleteAllVillagers() async {
    final db = await database;
    return await db.delete(VillagerTable.table);
  }
}
