import 'package:sqflite/sqflite.dart';

abstract class DbProvider {
  Future<Database> database;
}