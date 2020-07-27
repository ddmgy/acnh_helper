import 'dart:convert';

import 'package:acnh_helper/database/table/sea_creature_table.dart';
import 'package:acnh_helper/model/sea_creature.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class SeaCreaturesProvider extends MuseumItemsProvider<SeaCreature> {
  List<SeaCreature> _items = [];
  @override
  List<SeaCreature> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(SeaCreatureTable.table);
    if (firstFetch) {
      final response = await api.getSeaCreatures();
      if (response.ok) {
        final maps = json.decode(response.body);
        final seaCreatures = List.generate(maps.length, (i) {
          return SeaCreature.fromNetworkMap(maps[i]);
        }).toList();
        _items.addAll(seaCreatures);
        notifyListeners();
        for (var seaCreature in seaCreatures) {
          await db.insertSeaCreature(seaCreature);
        }
      } else {
        error = "Unable to connect to AC:NH API to get sea creatures information";
        notifyListeners();
      }
    } else {
      final seaCreatures = await db.getSeaCreatures();
      _items.addAll(seaCreatures);
      notifyListeners();
    }
    prefs.setFirstFetch(SeaCreatureTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<SeaCreature> seaCreatures) async {
    for (var seaCreature in seaCreatures) {
      await updateItem(seaCreature, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(SeaCreature seaCreature, {bool notify = true}) async {
    var index = _items.indexWhere((s) => s.id == seaCreature.id);
    _items[index] = seaCreature;
    await db.updateSeaCreature(seaCreature);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllSeaCreatures();
  }

  Future<void> resetSeaCreatures() async {
    await deleteAllItems();
    await prefs.setFirstFetch(SeaCreatureTable.table, true);
    loadItems();
  }
}