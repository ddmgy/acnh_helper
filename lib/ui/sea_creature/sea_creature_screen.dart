import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/sea_creature.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/ui/filter/sort_by_button.dart';
import 'package:acnh_helper/utils.dart';

class SeaCreatureScreen extends BaseScreen<SeaCreaturesProvider, SeaCreature> {
  @override
  String get name => "Sea creatures";

  @override
  String get itemType => ItemType.seaCreatures;

  @override
  String getSearchLabel() => "Search sea creatures";

  @override
  String getSearchSuggestionLabel() => "Filter sea creatures by name";

  @override
  String getSearchFailureLabel() => "No sea creatures found";

  @override
  List<String> getSearchFilters(SeaCreature item) => [
    item.name,
  ];

  @override
  List<Widget> getFilterByWidgets(BuildContext context) => [
    FilterByFoundButton(itemType: itemType),
    FilterByDonatedButton(itemType: itemType),
    FilterByCurrentlyAvailable(itemType: itemType),
    FilterByNewlyAvailable(itemType: itemType),
    FilterByLeavingSoon(itemType: itemType),
  ];

  @override
  List<Widget> getSortByWidgets(BuildContext context) => [
    SortAscendingButton(itemType: itemType),
    SortByButton(
      itemType: itemType,
      values: [
        SortBy.InGameOrder,
        SortBy.Name,
        SortBy.Speed,
        SortBy.Shadow,
        SortBy.SellPrice,
      ],
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<SeaCreaturesProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.loadItems();
      return;
    }

    final response = await api.getSeaCreatures();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return SeaCreature.fromNetworkMap(maps[i]);
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
  void navigateToDetailsScreen(BuildContext context, SeaCreature item) {
    Navigator.of(context).pushNamed(
      Routes.seaCreatureDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, SeaCreature item) {
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;

    return [
      InfoChip(
        title: "Found",
        color: AppColors.foundColor,
        visible: item.found,
      ),
      InfoChip(
        title: "Donated",
        color: AppColors.donatedColor,
        visible: item.donated,
      ),
      InfoChip(
        title: "Available",
        color: AppColors.currentlyAvailableColor,
        visible: item.isCurrentlyAvailable(calendarOptions),
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, SeaCreature item) {
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;

    return [
      InfoBadge(
        color: AppColors.foundColor,
        visible: item.found && !item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: AppColors.donatedColor,
        visible: item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: AppColors.currentlyAvailableColor,
        visible: item.isCurrentlyAvailable(calendarOptions),
        alignment: Alignment.topLeft,
      ),
    ];
  }
}