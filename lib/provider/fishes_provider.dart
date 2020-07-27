import 'dart:convert';

import 'package:acnh_helper/database/table/fish_table.dart';
import 'package:acnh_helper/model/fish.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class FishesProvider extends MuseumItemsProvider<Fish> {
  List<Fish> _items = [];
  @override
  List<Fish> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(FishTable.table);
    if (firstFetch) {
      final response = await api.getFishes();
      if (response.ok) {
        final maps = json.decode(response.body);
        final fishes = List.generate(maps.length, (i) {
          return Fish.fromNetworkMap(maps[i]);
        }).toList();
        _items.addAll(fishes);
        notifyListeners();
        for (var fish in fishes) {
          await db.insertFish(fish);
        }
      } else {
        error = "Unable to connect to AC:NH API to get fishes information";
        notifyListeners();
      }
    } else {
      final fishes = await db.getFishes();
      _items.addAll(fishes);
      notifyListeners();
    }
    prefs.setFirstFetch(FishTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<Fish> fishes) async {
    for (var fish in fishes) {
      await updateItem(fish, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(Fish fish, {bool notify = true}) async {
    var index = _items.indexWhere((f) => f.id == fish.id);
    _items[index] = fish;
    await db.updateFish(fish);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllFishes();
  }

  Future<void> resetFishes() async {
    await deleteAllItems();
    await prefs.setFirstFetch(FishTable.table, true);
    loadItems();
  }
}