import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/art.dart';
import 'package:acnh_helper/provider/arts_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/utils.dart';

class ArtScreen extends BaseScreen<ArtsProvider, Art> {
  @override
  String get name => "Art";

  @override
  String get itemType => ItemType.arts;

  @override
  String getSearchLabel() => "Search art";

  @override
  String getSearchSuggestionLabel() => "Filter art by name";

  @override
  String getSearchFailureLabel() => "No art found";

  @override
  List<String> getSearchFilters(Art item) => [
    item.name,
  ];

  @override
  List<Widget> getFilterByWidgets(BuildContext context) => [
    FilterByFoundButton(itemType: itemType),
    FilterByDonatedButton(itemType: itemType),
  ];

  @override
  List<Widget> getSortByWidgets(BuildContext context) => [
    SortAscendingButton(itemType: itemType),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<ArtsProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.loadItems();
      return;
    }

    final response = await api.getArts();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Art.fromNetworkMap(maps[i]);
      });
      final dbItems = provider.items;

      for (int i = 0; i < dbItems.length; i++) {
        var dbItem = dbItems[i];
        var j = networkItems.indexWhere((item) => item.id == dbItem.id);
        var item = networkItems[j]
          ..found = dbItem.found
          ..donated = dbItem.donated;
        networkItems[j] = item;
      }

      provider.updateAllItems(networkItems);
    }
  }

  @override
  void navigateToDetailsScreen(BuildContext context, Art item) {
    Navigator.of(context).pushNamed(
      Routes.artDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, Art item) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);

    return [
      InfoChip(
        title: "Found",
        color: prefs.foundColor,
        visible: item.found,
      ),
      InfoChip(
        title: "Donated",
        color: prefs.donatedColor,
        visible: item.donated,
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Art item) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);

    return [
      InfoBadge(
        color: prefs.foundColor,
        visible: item.found && !item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: prefs.donatedColor,
        visible: item.donated,
        alignment: Alignment.topRight,
      ),
    ];
  }
}