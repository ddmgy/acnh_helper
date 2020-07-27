import 'package:flutter/material.dart';

import 'package:acnh_helper/acnhapi.dart';
import 'package:acnh_helper/database/database_helper.dart';
import 'package:acnh_helper/preference/preferences_helper.dart';
import 'package:acnh_helper/utils.dart';

abstract class MuseumItemsProvider<T> extends ChangeNotifier {
  final AcnhApi api = AcnhApi.instance;
  final DatabaseHelper db = DatabaseHelper.instance;
  final PreferencesHelper prefs = PreferencesHelper.instance;

  List<T> get items;

  String error;
  bool get hasError => error.isNotNullOrEmpty;

  MuseumItemsProvider();

  Future<void> loadItems();

  Future<void> updateAllItems(List<T> items);

  Future<void> updateItem(T item, {bool notify = true});

  Future<void> deleteAllItems();
}