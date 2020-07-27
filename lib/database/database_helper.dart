import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:acnh_helper/database/art_mixin.dart';
import 'package:acnh_helper/database/bug_mixin.dart';
import 'package:acnh_helper/database/db_provider.dart';
import 'package:acnh_helper/database/fish_mixin.dart';
import 'package:acnh_helper/database/fossil_mixin.dart';
import 'package:acnh_helper/database/sea_creature_mixin.dart';
import 'package:acnh_helper/database/villager_mixin.dart';
import 'package:acnh_helper/utils.dart';

class DatabaseHelper extends DbProvider
  with ArtMixin, BugMixin, FishMixin, FossilMixin, SeaCreatureMixin, VillagerMixin
  {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  final int _dbVersion = 1;
  final String _dbFilename = "acnh_helper.db";

  DatabaseHelper._internal();

  Future<Database> _initDatabase() async {
    String databasePath;
    if (Platform.isWindows || Platform.isLinux) {
      // https://github.com/tekartik/sqflite/blob/develop/sqflite_common_ffi/doc/using_ffi_instead_of_sqflite.md
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      databasePath = await expandUser("~/.acnh_helper/$_dbFilename");
    } else {
      databasePath = p.join(await getDatabasesPath(), _dbFilename);
    }

    final Database db = await openDatabase(
      databasePath,
      version: _dbVersion,
      singleInstance: true,
      onCreate: (db, version) async {
        await createArtsTable(db);
        await createBugsTable(db);
        await createFishesTable(db);
        await createFossilsTable(db);
        await createSeaCreaturesTable(db);
        await createVillagersTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );

    return db;
  }
}