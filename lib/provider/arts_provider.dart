import 'dart:convert';

import 'package:acnh_helper/database/table/art_table.dart';
import 'package:acnh_helper/model/art.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/utils.dart';

class ArtsProvider extends MuseumItemsProvider<Art> {
  List<Art> _items = [];
  @override
  List<Art> get items => _items;

  @override
  Future<void> loadItems() async {
    _items = [];
    error = null;
    notifyListeners();

    final firstFetch = await prefs.getFirstFetch(ArtTable.table);
    if (firstFetch) {
      final response = await api.getArts();
      if (response.ok) {
        final maps = json.decode(response.body);
        final arts = List.generate(maps.length, (i) {
          return Art.fromNetworkMap(maps[i]);
        }).toList();
        _items.addAll(arts);
        notifyListeners();
        for (var art in arts) {
          await db.insertArt(art);
        }
      } else {
        error = "Unable to connect to AC:NH API to get arts information";
        notifyListeners();
      }
    } else {
      final arts = await db.getArts();
      _items.addAll(arts);
      notifyListeners();
    }
    prefs.setFirstFetch(ArtTable.table, false);
  }

  @override
  Future<void> updateAllItems(List<Art> arts) async {
    for (var art in arts) {
      await updateItem(art, notify: false);
    }
    notifyListeners();
  }

  @override
  Future<void> updateItem(Art art, {bool notify = true}) async {
    var index = _items.indexWhere((a) => a.id == art.id);
    _items[index] = art;
    await db.updateArt(art);
    if (notify) {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteAllItems() async {
    await db.deleteAllArts();
  }

  Future<void> resetArts() async {
    await deleteAllItems();
    await prefs.setFirstFetch(ArtTable.table, true);
    loadItems();
  }
}