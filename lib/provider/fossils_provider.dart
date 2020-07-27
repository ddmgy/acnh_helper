import 'dart:convert';

import 'package:acnh_helper/database/table/fossil_table.dart';
import 'package:acnh_helper/model/fossil.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class FossilsProvider extends MuseumItemsProvider<Fossil> {
  List<Fossil> _items = [];
  @override
  List<Fossil> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(FossilTable.table);
    if (firstFetch) {
      final response = await api.getFossils();
      if (response.ok) {
        final maps = json.decode(response.body);
        final fossils = List.generate(maps.length, (i) {
          return Fossil.fromNetworkMap(i + 1, maps[i]);
        }).toList();
        _items.addAll(fossils);
        notifyListeners();
        for (var fossil in fossils) {
          await db.insertFossil(fossil);
        }
      } else {
        error = "Unable to connect to AC:NH API to get fossils information";
        notifyListeners();
      }
    } else {
      final fossils = await db.getFossils();
      _items.addAll(fossils);
      notifyListeners();
    }
    prefs.setFirstFetch(FossilTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<Fossil> fossils) async {
    for (var fossil in fossils) {
      await updateItem(fossil, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(Fossil fossil, {bool notify = true}) async {
    var index = _items.indexWhere((f) => f.id == fossil.id);
    _items[index] = fossil;
    await db.updateFossil(fossil);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllFossils();
  }

  Future<void> resetFossils() async {
    await deleteAllItems();
    await prefs.setFirstFetch(FossilTable.table, true);
    loadItems();
  }
}