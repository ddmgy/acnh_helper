import 'dart:convert';

import 'package:acnh_helper/database/table/villager_table.dart';
import 'package:acnh_helper/model/villager.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class VillagersProvider extends MuseumItemsProvider<Villager> {
  List<Villager> _items = [];
  @override
  List<Villager> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(VillagerTable.table);
    if (firstFetch) {
      final response = await api.getVillagers();
      if (response.ok) {
        final maps = json.decode(response.body);
        final villagers = List.generate(maps.length, (i) {
          return Villager.fromNetworkMap(maps[i]);
        }).toList();
        _items.addAll(villagers);
        notifyListeners();
        for (var villager in villagers) {
          await db.insertVillager(villager);
        }
      } else {
        error = "Unable to connect to AC:NH API to get villagers information";
        notifyListeners();
      }
    } else {
      final villagers = await db.getVillagers();
      _items.addAll(villagers);
      notifyListeners();
    }
    prefs.setFirstFetch(VillagerTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<Villager> villagers) async {
    for (var villager in villagers) {
      await updateItem(villager, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(Villager villager, {bool notify = true}) async {
    var index = _items.indexWhere((v) => v.id == villager.id);
    _items[index] = villager;
    await db.updateVillager(villager);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllVillagers();
  }

  Future<void> resetVillagers() async {
    await deleteAllItems();
    await prefs.setFirstFetch(VillagerTable.table, true);
    loadItems();
  }
}