import 'dart:convert';

import 'package:acnh_helper/database/table/bug_table.dart';
import 'package:acnh_helper/model/bug.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class BugsProvider extends MuseumItemsProvider<Bug> {
  List<Bug> _items = [];
  @override
  List<Bug> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(BugTable.table);
    if (firstFetch) {
      final response = await api.getBugs();
      if (response.ok) {
        final maps = json.decode(response.body);
        final bugs = List.generate(maps.length, (i) {
          return Bug.fromNetworkMap(maps[i]);
        }).toList();
        _items.addAll(bugs);
        notifyListeners();
        for (var bug in bugs) {
          await db.insertBug(bug);
        }
      } else {
        error = "Unable to connect to AC:NH API to get bugs information";
        notifyListeners();
      }
    } else {
      final bugs = await db.getBugs();
      _items.addAll(bugs);
      notifyListeners();
    }
    prefs.setFirstFetch(BugTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<Bug> bugs) async {
    for (var bug in bugs) {
      await updateItem(bug, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(Bug bug, {bool notify = true}) async {
    var index = _items.indexWhere((b) => b.id == bug.id);
    _items[index] = bug;
    await db.updateBug(bug);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllBugs();
  }

  Future<void> resetBugs() async {
    await deleteAllItems();
    await prefs.setFirstFetch(BugTable.table, true);
    loadItems();
  }
}