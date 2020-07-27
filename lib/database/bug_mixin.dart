import 'package:sqflite/sqflite.dart';

import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/table/bug_table.dart';
import 'package:acnh_helper/model/bug.dart';

mixin BugMixin on DbProvider {
  Future<void> createBugsTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS ${BugTable.table}(
      ${BugTable.colId} INTEGER PRIMARY KEY,
      ${BugTable.colName} TEXT NOT NULL,
      ${BugTable.colImageUri} TEXT NOT NULL,
      ${BugTable.colThumbnailUri} TEXT NOT NULL,
      ${BugTable.colSellPrice} INTEGER NOT NULL,
      ${BugTable.colFound} INTEGER NOT NULL,
      ${BugTable.colDonated} INTEGER NOT NULL,
      ${BugTable.colMonthsAvailableNorthern} INTEGER NOT NULL,
      ${BugTable.colMonthsAvailableSouthern} INTEGER NOT NULL,
      ${BugTable.colTimesAvailable} INTEGER NOT NULL,
      ${BugTable.colLocation} TEXT NOT NULL
    )""");
  }

  Future<List<Bug>> getBugs() async {
    final db = await database;
    final maps = await db.query(BugTable.table);

    return List.generate(maps.length, (i) {
      return Bug.fromMap(maps[i]);
    });
  }

  Future<int> insertBug(Bug bug) async {
    final db = await database;
    return await db.insert(
      BugTable.table,
      bug.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateBug(Bug bug) async {
    final db = await database;
    return await db.update(
      BugTable.table,
      bug.toMap(),
      where: "${BugTable.colId} = ?",
      whereArgs: [bug.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBug(Bug bug) async {
    final db = await database;
    return await db.delete(
      BugTable.table,
      where: "${BugTable.colId} = ?",
      whereArgs: [bug.id],
    );
  }

  Future<int> deleteAllBugs() async {
    final db = await database;
    return await db.delete(BugTable.table);
  }
}
